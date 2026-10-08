class_name PigsterRagdoll
extends Node2D

@export var part_material: PhysicsMaterial
@export var burst_force: float = 100.0
@export var spread_force: float = 100.0
@export var lift_force: float = 100.0
@export var max_spin: float = 1.0


func _ready() -> void:
	for part in _get_parts():
		part.physics_material_override = part_material
		part.continuous_cd = RigidBody2D.CCD_MODE_CAST_RAY


func burst(hit_position: Vector2, direction: Vector2) -> void:
	for part in _get_parts():
		var away := (part.global_position - hit_position).normalized()
		var push := direction * burst_force + away * spread_force + Vector2.UP * lift_force
		push *= randf_range(0.7, 1.3)
		part.apply_central_impulse(push)
		part.angular_velocity = randf_range(-max_spin, max_spin)


func _get_parts() -> Array[RigidBody2D]:
	var parts: Array[RigidBody2D] = []
	for child in get_children():
		var part := child as RigidBody2D
		if part != null:
			parts.append(part)
	return parts
