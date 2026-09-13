class_name DifficultyManager extends Node

## Number of [MicrogameQueue] stages until the difficulty plateaus
const DIFFICULTY_PLATEAU_NUM : int = 3

signal difficulty_changed(difficulty : float)


@export var difficulty_curve : Curve

## Current difficulty for a stage, based on the [member DIFFICULTY_PLATEAU_NUM] value
## and the [member difficulty_curve]. Always clamped to range of [0.0, 1.0]
var current_difficulty : float = 0:
	set(value):
		current_difficulty = clampf(value, 0.0, 1.0)
		difficulty_changed.emit(current_difficulty)


func _on_microgame_stage_finished(num_completed : int) -> void:
	# remaps number of stages completed to range of [0.0, 1.0] depending
	# on how many games we want the player to complete before the difficulty
	# plateaus on DIFFICULTY_PLATEAU_NUM
	var difficulty_offset : float = remap(num_completed, 0, DIFFICULTY_PLATEAU_NUM, 0.0, 1.0)
	
	# set current_difficulty to sampled curve
	current_difficulty = difficulty_curve.sample(difficulty_offset)
