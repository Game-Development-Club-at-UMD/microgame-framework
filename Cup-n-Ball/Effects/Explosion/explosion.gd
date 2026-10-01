extends Node2D
## Full-screen explosion. The Fireball node's shader is driven by the AnimationPlayer
## and covers the whole screen on its own CanvasLayer, centred on the blast.

signal finished

@onready var screen: CanvasLayer = $Screen
@onready var fireball: ColorRect = $Screen/Fireball
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func detonate(at: Vector2) -> void:
	global_position = at
	var material := fireball.material as ShaderMaterial
	var screen_size := get_viewport().get_visible_rect().size
	var origin := get_global_transform_with_canvas().origin

	# Distance to the farthest corner, so the blast always reaches every edge.
	var reach := 0.0
	for corner in [Vector2.ZERO, Vector2(screen_size.x, 0.0), Vector2(0.0, screen_size.y), screen_size]:
		reach = maxf(reach, origin.distance_to(corner))

	material.set_shader_parameter("center", origin / screen_size)
	material.set_shader_parameter("aspect", screen_size.x / screen_size.y)
	material.set_shader_parameter("reach", reach / screen_size.y)
	# New noise pattern every blast so no two explosions look the same.
	material.set_shader_parameter("noise_seed", randf() * 100.0)

	screen.show()
	animation_player.stop()
	animation_player.play("explode")


# The smoke stays on screen; the microgame's lose transition fades out from it.
func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	finished.emit()
