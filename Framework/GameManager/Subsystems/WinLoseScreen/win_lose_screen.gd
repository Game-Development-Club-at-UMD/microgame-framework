class_name WinLoseScreen extends Control

# fade in/out
@onready var fade_to_black: ControlTween = %FadeToBlack
@onready var fade_from_black: ControlTween = %FadeFromBlack
# stat displays
@onready var lives_stat_display: FloatStatDisplay = %LivesStatDisplay
@onready var wins_stat_display: FloatStatDisplay = %WinsStatDisplay
@onready var difficulty_stat_display: FloatStatDisplay = %DifficultyStatDisplay

@export var win_anims_pool : Array[PackedScene]
@export var lose_anims_pool : Array[PackedScene]

var old_save_data : SaveData = SaveData.new()
var new_save_data : SaveData = SaveData.new()

const PAUSE_AMOUNT : float = 1.5


func _ready() -> void:
	self.visible = false


func play_anim() -> void:
	# setting the stat displays up
	lives_stat_display.set_ui_with_no_anim(old_save_data.lives)
	wins_stat_display.set_ui_with_no_anim(old_save_data.wins)
	difficulty_stat_display.set_ui_with_no_anim(old_save_data.current_difficulty)
	
	# do fade in
	self.visible = true
	
	# DO SILLY CUSTOM ART ANIMS:
	# if player lost lives, they must've lost
	#if new_save_data.lives < old_save_data.lives:
		#lose_anims_pool.shuffle()
		#await play_silly_anim(lose_anims_pool.get(0))
	## if player didnt lose lives, they must've won!
	#else:
		#win_anims_pool.shuffle()
		#await play_silly_anim(win_anims_pool.get(0))
	
	# do stat change anims
	await lives_stat_display.do_anim(new_save_data.lives)
	await wins_stat_display.do_anim(new_save_data.wins)
	await difficulty_stat_display.do_anim(new_save_data.current_difficulty)
	
	
	get_tree().create_timer(0.5)
	
	lives_stat_display.fade_out()
	wins_stat_display.fade_out()
	await difficulty_stat_display.fade_out()
	
	self.visible = false
	
	old_save_data.lives = new_save_data.lives
	old_save_data.wins = new_save_data.wins
	old_save_data.current_difficulty = new_save_data.current_difficulty


func play_silly_anim(packed_scene : PackedScene) -> void:
	if packed_scene == null:
		push_warning("%s: Could not play silly anim for a null anim! Check the win/lose anim pool" % self)
		return
	var instanced_scene = packed_scene.instantiate()
	if instanced_scene is not WinLoseCustomAnimation:
		return
	self.add_child(instanced_scene)
	await (instanced_scene as WinLoseCustomAnimation).anim_finished


#region recording whether values have changed
func _on_lives_changed(old : int, new : int) -> void:
	old_save_data.lives = old
	new_save_data.lives = new


func _on_wins_changed(old : int, new : int) -> void:
	old_save_data.wins = old
	new_save_data.wins = new


func _on_difficulty_changed(old : float, new : float) -> void:
	old_save_data.current_difficulty = old
	new_save_data.current_difficulty = new
#endregion
