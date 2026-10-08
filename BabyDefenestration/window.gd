extends Node2D

var dir: int = 1

func _ready() -> void:
	position = Vector2(0, 324)

func _process(_delta: float) -> void: #0.2 -> 6 units (6*8 = 48 pixels); 0.6 -> 18 units
	if GameManager.difficulty_manager.current_difficulty >= 0.5:
		$".".position.y += 3 * dir
		if $".".position.y >= 648 - (scale.y*30*8): 
			dir *= -1
		elif $".".position.y <= scale.y*30*8:
			dir *= -1
