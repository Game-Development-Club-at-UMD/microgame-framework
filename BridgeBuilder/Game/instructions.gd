extends Node2D

@onready var instructions: Node2D = $"."

func _on_timer_timeout() -> void:
	instructions.queue_free()
