extends Node

@onready var fade_to_black: ControlTween = %FadeToBlack as ControlTween
@onready var fade_from_black: ControlTween = %FadeFromBlack as ControlTween
@onready var microgame_queue: MicrogameQueue = %MicrogameQueue as MicrogameQueue
@onready var difficulty_manager: DifficultyManager = %DifficultyManager as DifficultyManager
@onready var save_data_manager: SaveDataManager = %SaveDataManager as SaveDataManager

signal game_won
signal game_lost

func _ready() -> void:
	# connecting the microgame_queue to the difficult_manager
	microgame_queue.stage_finished.connect(difficulty_manager._on_microgame_stage_finished)
	game_won.connect(save_data_manager._handle_won_game)
	game_lost.connect(save_data_manager._handle_lost_game)
	difficulty_manager.difficulty_changed.connect(save_data_manager._on_difficulty_chnaged)


func unpause_game() -> void:
	get_tree().paused = false


func pause_game() -> void:
	get_tree().paused = true


func start_microgame() -> void:
	_switch_to_next_microgame()


func switch_scene_to_packed(scene : PackedScene) -> void:
	pause_game()
	fade_to_black.do_tween()
	await fade_to_black.tween.finished
	
	get_tree().change_scene_to_packed(scene)
	
	fade_from_black.do_tween()
	await fade_from_black.tween.finished
	unpause_game()


func lose() -> void:
	pause_game()
	game_lost.emit()
	_switch_to_next_microgame()
	unpause_game()


func win() -> void:
	pause_game()
	game_won.emit()
	_switch_to_next_microgame()
	unpause_game()


func _switch_to_next_microgame() -> void:
	# Reset the mouse cursor to default (so each game can have their own)
	Input.set_custom_mouse_cursor(null)
	
	fade_to_black.do_tween()
	await fade_to_black.tween.finished
	
	var next_packed_scene : PackedScene = await microgame_queue.get_next_game()
	var next_microgame : Node = next_packed_scene.instantiate()
	
	if next_microgame is not MicroGame:
		push_error("%s: %s is not of type MicroGame but is in the microgame_queue" % [self, next_microgame])
		return
	
	(next_microgame as MicroGame).difficulty = difficulty_manager.current_difficulty
	
	get_tree().change_scene_to_node(next_microgame)
	
	fade_from_black.do_tween()
	await fade_from_black.tween.finished
