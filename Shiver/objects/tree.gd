extends Node3D

@onready var raycast = $"RayCast3D"

func find_the_ground() -> void:
	raycast.force_raycast_update()
	if raycast.get_collider():
		position.y = raycast.get_collision_point().y
	else:
		position.y = -5
