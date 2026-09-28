class_name CharacterHandler
extends Node2D

@export var character_pool: Array[RaceTrackCharacterStats]

@export_group("Appearance")
@export var character_scene: PackedScene

#Scale of the character sprite (since all tracks are scaled differently)
@export_range(0.1, 10.0, 0.01) var character_scale: float = 1.0

@export_group("Spawn Areas")
# Drag the Area2Ds per checkpoin in the inspector (in chronological order)
@export var spawn_areas: Array[Area2D]
# Margin for the spawn area so characters don't spawn right on the edges
@export var edge_margin: Vector2 = Vector2(20, 20)

var characters: Array[AnimatedSprite2D] = []


func spawn_characters(track_anchors: Array[Transform2D]) -> void:
	_clear_existing()
	
	if character_pool.is_empty():
		return
	
	var pool := character_pool.duplicate()
	pool.shuffle()
	
	for i in track_anchors.size():
		var stats: RaceTrackCharacterStats = (
			pool[i] if i < pool.size() else pool[randi() % pool.size()]
		)
	
		var sprite := _instantiate_character()
		sprite.name = "Character%d" % i
		sprite.sprite_frames = stats.character_sprite_frames
		sprite.scale *= character_scale 
		sprite.position = to_local(_random_point_in_area(i, track_anchors[i].origin))
		add_child(sprite)
	
		characters.append(sprite)


func _random_point_in_area(index: int, fallback: Vector2) -> Vector2:
	if index >= spawn_areas.size() or spawn_areas[index] == null:
		return fallback
	
	var rectangles: Array[CollisionShape2D] = []
	for child in spawn_areas[index].get_children():
		var shape_node := child as CollisionShape2D
		if shape_node and not shape_node.disabled and shape_node.shape is RectangleShape2D:
			rectangles.append(shape_node)
	
	if rectangles.is_empty():
		return fallback
	
	var spawn_shape_node: CollisionShape2D = rectangles[randi() % rectangles.size()]
	var half_of_area: Vector2 = (spawn_shape_node.shape as RectangleShape2D).size * 0.5
	# Converts margin to local space
	var margin_local: Vector2 = edge_margin / spawn_shape_node.global_scale.abs()

	var inner_half := Vector2(
		half_of_area.x - margin_local.x,
		half_of_area.y - margin_local.y
	)
	var local_point := Vector2(
		randf_range(-inner_half.x, inner_half.x),
		randf_range(-inner_half.y, inner_half.y)
	
	)
	# to_global respects the shape's position, rotation and scale.
	return spawn_shape_node.to_global(local_point)


func _instantiate_character() -> AnimatedSprite2D:
	if character_scene:
		var instance := character_scene.instantiate()
		if instance is AnimatedSprite2D:
			return instance
	
		instance.queue_free()
	return AnimatedSprite2D.new()


func _clear_existing() -> void:
	for character in characters:
		if is_instance_valid(character):
			character.queue_free()
	characters.clear()
