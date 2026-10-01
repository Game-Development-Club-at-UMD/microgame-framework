extends Node2D
## The cup pumping electricity into a caught ball. Sticks to the ball while it plays,
## then emits `finished` when the charge peaks.

signal finished

var target: Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func zap(ball: Node2D) -> void:
	target = ball
	global_position = ball.global_position
	animation_player.stop()
	animation_player.play("zap")


func _physics_process(_delta: float) -> void:
	if is_instance_valid(target):
		global_position = target.global_position


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	target = null
	hide()
	finished.emit()
