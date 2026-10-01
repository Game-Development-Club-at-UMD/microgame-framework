extends  CharacterBody2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var points = []
	for segment in self.get_children().filter(func (c): return c is RigidBody2D):
		for joint in segment.get_children().filter(func (c): return c is PinJoint2D):
			points.append(joint.global_position)
	
	var smooth_points = catmull_rom_spline(points)
	$Line2D.points = smooth_points


func catmull_rom_spline(
	_points: Array, resolution: int = 10, extrapolate_end_points = true
) -> PackedVector2Array:
	var points = _points.duplicate()
	if extrapolate_end_points:
		points.insert(0, points[0] - (points[1] - points[0]))
		points.append(points[-1] + (points[-1] - points[-2]))

	var smooth_points := PackedVector2Array()
	if points.size() < 4:
		return points

	for i in range(1, points.size() - 2):
		var p0 = points[i - 1]
		var p1 = points[i]
		var p2 = points[i + 1]
		var p3 = points[i + 2]

		for t in range(0, resolution):
			var tt = t / float(resolution)
			var tt2 = tt * tt
			var tt3 = tt2 * tt

			var q = (
				0.5
				* (
					(2.0 * p1)
					+ (-p0 + p2) * tt
					+ (2.0 * p0 - 5.0 * p1 + 4 * p2 - p3) * tt2
					+ (-p0 + 3.0 * p1 - 3.0 * p2 + p3) * tt3
				)
			)

			smooth_points.append(q)

	return smooth_points


func _physics_process(delta: float): 
	position = get_global_mouse_position()
	

	
