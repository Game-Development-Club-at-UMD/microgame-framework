class_name BubbleInstructionScreen extends Control

signal can_start

@onready var disappear: ControlTween = $Disappear as ControlTween
@onready var mouse_animation_player: AnimationPlayer = $Mouse/AnimationPlayer as AnimationPlayer
@onready var pop_animation_player: AnimationPlayer = $Pop/AnimationPlayer as AnimationPlayer


func do_introduction() -> void:
	mouse_animation_player.play("MOUSE")
	pop_animation_player.play("POP")
	await get_tree().create_timer(3).timeout
	disappear.do_tween()
	await disappear.tween.finished
	can_start.emit()
