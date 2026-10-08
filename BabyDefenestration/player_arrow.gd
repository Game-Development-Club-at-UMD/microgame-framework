extends Polygon2D

@onready var difficulty = GameManager.difficulty_manager.current_difficulty
@onready var rotationSpeed : float = 2.0 + difficulty
@onready var launchSpeed : float = 0.02 + difficulty*.1

var move_direction : String = "left"

func _launch_angle() -> void:
	if rotation_degrees >= 45.0:
		move_direction = 'left'
	if rotation_degrees <= -45.0:
		move_direction = 'right'
	if move_direction == 'left':
		rotation_degrees -= rotationSpeed
	if move_direction == 'right':
		rotation_degrees += rotationSpeed

func _launch() -> void:
	if scale.x <= 0.5:
		move_direction = "right"
	if scale.x >= 1.0:
		move_direction = "left"
	if move_direction == "left":
		scale.x -= launchSpeed
	elif move_direction == "right":
		scale.x += launchSpeed
