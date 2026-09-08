class_name MicrogameQueue extends Node

@export var microgames : Array[PackedScene]

var microgames_in_stage : Array[PackedScene]
var num_completed_stages : int = 0

@warning_ignore("unused_signal")
signal stage_finished(num_completed : int)

func _ready() -> void:
	validate_microgames()


func validate_microgames() -> void:
	# TODO: validate that they are all microgames
	for game in microgames:
		pass


func get_next_game() -> PackedScene:
	var next_game : PackedScene = microgames_in_stage.pop_front()
	# player finished all levels in stage
	if next_game == null:
		await finish_stage()
		next_game = microgames_in_stage.pop_front()
	return next_game


func finish_stage() -> void:
	stage_finished.emit(num_completed_stages)
	microgames_in_stage = microgames.duplicate()
	# ensures random order
	microgames_in_stage.shuffle()
	await get_tree().process_frame
