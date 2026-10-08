extends Node2D

@onready var timer: Timer = $Timer
@onready var label: Label = $Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var time_left : float = timer.time_left
	label.text = str(ceil(time_left))
