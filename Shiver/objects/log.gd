extends RigidBody3D

@onready var collision_shape = $"CollisionShape3D"

func launch_with_velocity(launch_velocity: Vector3) -> void:
	apply_impulse(Vector3(launch_velocity.x, launch_velocity.y * 0.1, launch_velocity.z))

func stop_working() -> void:
	freeze = true
	collision_shape.disabled = true

func start_working() -> void:
	freeze = false
	collision_shape.disabled = false
