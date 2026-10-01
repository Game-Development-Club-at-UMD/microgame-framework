extends Node2D
## Celebration pop: a bright flash plus two confetti emitters (squares and strips).

signal finished

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func burst(at: Vector2) -> void:
	global_position = at
	show()
	animation_player.stop()
	animation_player.play("burst")


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	hide()
	finished.emit()
