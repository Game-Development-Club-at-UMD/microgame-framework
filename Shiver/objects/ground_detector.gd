extends RayCast3D

## Used to place objects correctly.
func detect_and_return_spawn_pos_y() -> float:
	force_raycast_update()
	if is_colliding():
		return get_collision_point().y
	return 20

func _ready() -> void:
	get_parent().position.y = detect_and_return_spawn_pos_y()
	print(str(get_parent()) + str(get_parent().position.y))
