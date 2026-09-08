class_name MicrogameQueue extends Node

@export var microgames : Array[PackedScene]

var _microgames_in_stage : Array[PackedScene]
var _num_completed_stages : int = 0

@warning_ignore("unused_signal")
## Emits once each [MicroGame] has been finished in a given stage
signal stage_finished(num_completed : int)


func _ready() -> void:
	_validate_microgames()
	_setup_new_stage()


func get_next_game() -> PackedScene:
	var next_game : PackedScene = _microgames_in_stage.pop_front()
	# player finished all levels in stage
	if next_game == null:
		await _finish_stage()
		next_game = _microgames_in_stage.pop_front()
	return next_game


func _validate_microgames() -> void:
	# TODO: validate that they are all microgames
	microgames.filter(_filter_null_packed_scenes)


func _setup_new_stage() -> void:
	_microgames_in_stage = microgames.duplicate()
	_microgames_in_stage.shuffle()


func _finish_stage() -> void:
	stage_finished.emit(_num_completed_stages)
	_setup_new_stage()
	await get_tree().process_frame


func _filter_null_packed_scenes(a : PackedScene) -> bool:
	if a == null:
		return false
	return true
