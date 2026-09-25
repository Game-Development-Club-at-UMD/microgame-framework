extends Node

@onready var fade_to_black: ControlTween = %FadeToBlack as ControlTween
@onready var fade_from_black: ControlTween = %FadeFromBlack as ControlTween
@onready var microgame_queue: MicrogameQueue = %MicrogameQueue as MicrogameQueue
@onready var difficulty_manager: DifficultyManager = %DifficultyManager as DifficultyManager
@onready var save_data_manager: SaveDataManager = %SaveDataManager as SaveDataManager
@onready var win_lose_screen: WinLoseScreen = %WinLoseScreen
@onready var mouse_paw: PawMouseIcon = $MousePaw as PawMouseIcon

const MAIN_MENU = preload("uid://da4hhvghhnoi8")
const PAUSE_MENU = preload("uid://b83ydhdbt5js")

## For microgames, use the GameManager.win() func instead of emitting this signal manually
signal game_won
## For microgames, use the GameManager.lose() func instead of emitting this signal manually
signal game_lost

var current_pause_menu : PauseMenu
var is_ending_microgame : bool = false

func _ready() -> void:
	# connecting the microgame_queue to the difficult_manager
	microgame_queue.stage_finished.connect(difficulty_manager._on_microgame_stage_finished)
	game_won.connect(save_data_manager._handle_won_game)
	game_lost.connect(save_data_manager._handle_lost_game)
	difficulty_manager.difficulty_changed.connect(save_data_manager._on_difficulty_chnaged)
	
	save_data_manager.save_data.difficulty_changed.connect(win_lose_screen._on_difficulty_changed)
	save_data_manager.save_data.wins_changed.connect(win_lose_screen._on_wins_changed)
	save_data_manager.save_data.lives_changed.connect(win_lose_screen._on_lives_changed)

func _physics_process(_delta: float) -> void:
	if !Input.is_action_just_pressed("pause"):
		return
	if get_tree().current_scene == null || get_tree().current_scene is not MicroGame:
		return
	if current_pause_menu != null:
		return
	
	current_pause_menu = PAUSE_MENU.instantiate() as PauseMenu
	
	get_tree().current_scene.add_child(current_pause_menu)

## DO NOT MANUALLY USE THIS IN YOUR MICROGAME
func unpause_game() -> void:
	get_tree().paused = false


## DO NOT MANUALLY USE THIS IN YOUR MICROGAME
func pause_game() -> void:
	#var tween : Tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	#tween.tween_property(Engine, "time_scale", target_scale, duration)
	#tween.set_ignore_time_scale()
	get_tree().paused = true


func start_microgame() -> void:
	mouse_paw.make_invisible()
	_switch_to_next_microgame()
	save_data_manager.save_data.clear()


func switch_scene_to_packed(scene : PackedScene) -> void:
	microgame_queue.clear()
	
	if get_tree().paused == false:
		pause_game()
		await fade_to_black.do_tween()
	
	get_tree().change_scene_to_packed(scene)
	
	await fade_from_black.do_tween()
	unpause_game()


func lose() -> void:
	if is_ending_microgame:
		return
	is_ending_microgame = true
	# fade out current microgame
	await _switch_from_current_microgame()
	
	game_lost.emit()
	
	# show current player stats
	await win_lose_screen.play_anim()
	
	# switch to next microgame
	_switch_to_next_microgame()
	is_ending_microgame = false


func win() -> void:
	if is_ending_microgame:
		return
	is_ending_microgame = true
	# fade out current microgame
	await _switch_from_current_microgame()
	
	game_won.emit()
	
	# show current player stats
	await win_lose_screen.play_anim()
	
	# switch to next microgame
	_switch_to_next_microgame()
	is_ending_microgame = false


func _switch_from_current_microgame() -> void:
	await fade_to_black.do_tween()
	microgame_queue.finish_game()
	get_tree().current_scene.queue_free()
	pause_game()
	await fade_from_black.do_tween()



func _switch_to_next_microgame() -> void:
	
	# Reset the mouse cursor to default (so each game can have their own)
	Input.set_custom_mouse_cursor(null)
	
	await fade_to_black.do_tween()
	
	if save_data_manager.save_data.lives <= 0:
		switch_scene_to_packed(MAIN_MENU)
		mouse_paw.make_visible()
		GameSaver.save_data_to_file(save_data_manager.save_data)
		return
	
	var next_packed_scene : PackedScene = await microgame_queue.get_next_game()
	var next_microgame : Node = next_packed_scene.instantiate()
	
	if next_microgame is not MicroGame:
		push_error("%s: %s is not of type MicroGame but is in the microgame_queue" % [self, next_microgame])
		return
	
	(next_microgame as MicroGame).difficulty = difficulty_manager.current_difficulty
	
	get_tree().change_scene_to_node(next_microgame)
	
	await fade_from_black.do_tween()
	
	if current_pause_menu == null:
		unpause_game()
	
