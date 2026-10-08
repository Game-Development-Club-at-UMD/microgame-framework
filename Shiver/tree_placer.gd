extends Node3D

@onready var game = get_parent()

const TREE = preload("res://Shiver/objects/tree.tscn")
var tree_count = 64
const TREE_MIN_RANGE = 2
const TREE_MAX_RANGE = 30

var started: bool = false

func start(the_game: Node) -> void:
	game = the_game
	started = true
	#for i in tree_count:
		#var new_tree = TREE.instantiate()
		#game.add_child(new_tree)
		#new_tree.position = Vector3(((randi_range(1, 2) * 2) - 3) * randf_range(TREE_MIN_RANGE, TREE_MAX_RANGE), 20, ((randi_range(1, 2) * 2) - 3) * randf_range(TREE_MIN_RANGE, TREE_MAX_RANGE))
		#new_tree.find_the_ground()

func _process(_delta: float) -> void:
	if started and tree_count:
		tree_count -= 1
		var new_tree = TREE.instantiate()
		game.add_child(new_tree)
		new_tree.position = Vector3(((randi_range(1, 2) * 2) - 3) * randf_range(TREE_MIN_RANGE, TREE_MAX_RANGE), 20, ((randi_range(1, 2) * 2) - 3) * randf_range(TREE_MIN_RANGE, TREE_MAX_RANGE))
		new_tree.find_the_ground()
