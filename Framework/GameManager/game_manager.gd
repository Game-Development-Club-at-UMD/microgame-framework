extends Node

@onready var fade_to_black: ControlTween = %FadeToBlack
@onready var fade_from_black: ControlTween = %FadeFromBlack
@onready var microgame_queue: MicrogameQueue = %MicrogameQueue
@onready var difficulty_manager: DifficultyManager = %DifficultyManager


func _ready() -> void:
	# connecting the microgame_queue to the difficult_manager
	microgame_queue.stage_finished.connect(difficulty_manager._on_microgame_stage_finished)
	#_switch_to_next_microgame()


func unpause_game() -> void:
	get_tree().paused = false


func pause_game() -> void:
	get_tree().paused = true


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
	# TODO: Count losses
	_switch_to_next_microgame()
	unpause_game()


func win() -> void:
	pause_game()
	# TODO: Count wins
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


# TODO: replace this with saving highscore
func _notification(what : int):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit()
