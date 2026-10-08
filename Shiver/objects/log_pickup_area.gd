extends Area3D

@export var player: CharacterBody3D

var all_bodies_inside_me: Array[RigidBody3D] = []

func _on_body_entered(body: Node3D) -> void:
	if body is RigidBody3D:
		all_bodies_inside_me.append(body)
		if all_bodies_inside_me.size() == 1 and player.all_held_logs.is_empty():
			player.instruction_text.set_text("[center](Click) Pick up")

func _on_body_exited(body: Node3D) -> void:
	if body is RigidBody3D and all_bodies_inside_me.has(body):
		all_bodies_inside_me.pop_at(all_bodies_inside_me.find(body))
		if all_bodies_inside_me.is_empty() and player.all_held_logs.is_empty():
			player.instruction_text.set_text("")
