class_name FailPathHandler
extends Node2D


@export_range(0.1, 1.0, 0.05) var handle_strength: float = 0.5
@export_range(0.0, 1.0, 0.05) var arrival_softness: float = 0.5

var fail_paths: Array[Path2D] = []

func build_fail_paths(track_anchors: Array[Transform2D], characters: Array[AnimatedSprite2D]) -> void:
	_clear_existing()
	
	for i in track_anchors.size():
		if i >= characters.size():
			break
	
		var fail_path := _build_single_fail_path(track_anchors[i], characters[i])
		fail_path.name = "FailPath%d" % i
		add_child(fail_path)
		fail_paths.append(fail_path)


func _build_single_fail_path(anchor: Transform2D, character: Node2D) -> Path2D:
	var start_local := to_local(anchor.origin)
	var end_local := to_local(character.global_position)
	var start_direction: Vector2 = get_global_transform().basis_xform_inv(anchor.x).normalized()
	var distance := start_local.distance_to(end_local)
	var departure_handle := start_direction * distance * handle_strength
	var arrival_direction := (end_local - start_local).normalized()
	var arrival_handle := -arrival_direction * distance * handle_strength * arrival_softness
	
	var curve := Curve2D.new()
	curve.add_point(start_local, Vector2.ZERO, departure_handle)
	curve.add_point(end_local, arrival_handle, Vector2.ZERO)
	
	var fail_path := Path2D.new()
	fail_path.position = Vector2.ZERO
	fail_path.curve = curve
	return fail_path


func _clear_existing() -> void:
	for child in get_children():
		child.queue_free()
	fail_paths.clear()
