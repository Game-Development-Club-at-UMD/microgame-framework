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
@export var chatter_label : ChatterLabel

@export_file("*.txt") var win_voicelines
@export_file("*.txt") var lose_voicelines

var old_save_data : SaveData = SaveData.new()
var new_save_data : SaveData = SaveData.new()
var tween_array : Array = []
var speed : float

const PAUSE_AMOUNT : float = 1.5


func _ready() -> void:
	self.visible = false
	for tween in find_children("*", "", true, false):
		if tween is ControlTween:
			tween_array.append(tween)

func play_anim() -> void:
	# setting the stat displays up
	chatter_label.visible = false
	lives_stat_display.set_ui_with_no_anim(old_save_data.lives)
	wins_stat_display.set_ui_with_no_anim(old_save_data.wins)
	difficulty_stat_display.set_ui_with_no_anim(old_save_data.current_difficulty)
	
	# do fade in
	self.visible = true
	
	# DO SILLY CUSTOM ART ANIMS:
	# if player lost lives, they must've lost
	if new_save_data.lives < old_save_data.lives:
		lose_anims_pool.shuffle()
		await play_silly_anim(lose_anims_pool.front())
	# if player didnt lose lives, they must've won!
	else:
		win_anims_pool.shuffle()
		await play_silly_anim(win_anims_pool.front())
	
	# do stat change anims
	chatter_label.visible = true
	chatter_label.modulate = Color.WHITE
	if new_save_data.lives < old_save_data.lives:
		chatter_label.dialogue_lines = chatter_label.LOSE_STRINGS
	else:
		chatter_label.dialogue_lines = chatter_label.WIN_STRINGS
	chatter_label.reset_temp_lines()
	chatter_label._on_timer_timeout()
	await lives_stat_display.do_anim(new_save_data.lives)
	await wins_stat_display.do_anim(new_save_data.wins)
	await difficulty_stat_display.do_anim(new_save_data.current_difficulty)
	
	await get_tree().create_timer(1.0).timeout
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(chatter_label, "modulate", Color.BLACK, 0.5)
	lives_stat_display.fade_out()
	wins_stat_display.fade_out()
	
	await difficulty_stat_display.fade_out()
	chatter_label.visible = false
	self.visible = false
	
	old_save_data.lives = new_save_data.lives
	old_save_data.wins = new_save_data.wins
	old_save_data.current_difficulty = new_save_data.current_difficulty


func play_silly_anim(packed_scene : PackedScene) -> void:
	if packed_scene == null:
		push_warning("%s: Could not play silly anim for a null anim! Check the win/lose anim pool" % self)
		return
		
	var instanced_scene = packed_scene.instantiate()
	
	if instanced_scene is not CustomAnimationScreen:
		return
	
	await fade_from_black.do_tween()
	
	self.add_child(instanced_scene)
	await (instanced_scene as CustomAnimationScreen).anim_finished
	
	await fade_to_black.do_tween()
	instanced_scene.queue_free()
	await fade_from_black.do_tween()


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
	
	speed = clampf(0.5 - new * 0.30, 0.1, 2.5)
	
	lives_stat_display.set_speed(speed)
	wins_stat_display.set_speed(speed)
	difficulty_stat_display.set_speed(speed)
	
	for tween in tween_array:
		tween.tween_duration = speed

#endregion
