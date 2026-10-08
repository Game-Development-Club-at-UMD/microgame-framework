extends Node3D

@onready var game = get_parent()

const FIREWOOD = preload("res://Shiver/objects/log.tscn")

func start(the_game: Node) -> void:
	game = the_game
	for i in 16:
		var new_firewood = FIREWOOD.instantiate() as RigidBody3D
		game.add_child(new_firewood)
		new_firewood.position = Vector3(((randi_range(1, 2) * 2) - 3) * randf_range(3, 30), 20, ((randi_range(1, 2) * 2) - 3) * randf_range(3, 30))
		new_firewood.apply_impulse(Vector3(0, -10, 0))
