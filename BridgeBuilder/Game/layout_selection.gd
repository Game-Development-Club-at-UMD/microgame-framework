extends Node2D

@export var main: BridgeBuilder

var Tutorial : PackedScene = preload("res://BridgeBuilder/map/tutorial.tscn")

var EasyLayouts : Array[PackedScene] = [
	preload("res://BridgeBuilder/map/EasyMaps/EasyFrowns.tscn"),
	preload("res://BridgeBuilder/map/EasyMaps/EasyOval.tscn"),
	preload("res://BridgeBuilder/map/EasyMaps/EasyPyramid.tscn"),
	preload("res://BridgeBuilder/map/EasyMaps/EasySmiles.tscn"),
	preload("res://BridgeBuilder/map/EasyMaps/EasyThreeBlocks.tscn")
]

var MedLayouts : Array[PackedScene] = [
	preload("res://BridgeBuilder/map/MediumMaps/MediumArrows.tscn"),
	preload("res://BridgeBuilder/map/MediumMaps/MediumRamp.tscn"),
	preload("res://BridgeBuilder/map/MediumMaps/MediumSpike.tscn"),
	preload("res://BridgeBuilder/map/MediumMaps/MediumSpikesPlural.tscn")
]

var HardLayouts : Array[PackedScene] = [
	preload("res://BridgeBuilder/map/HardMaps/HardHolesInWall.tscn"),
	preload("res://BridgeBuilder/map/HardMaps/HardThroughTheSphere.tscn"),
	preload("res://BridgeBuilder/map/HardMaps/HardWallOne.tscn")
]


func _ready() -> void:
	spawn_scene()
	
func spawn_scene() -> void:
	var scene_to_spawn : PackedScene
	
	# Spawns layout depending the current difficulty
	if main.difficulty == 0:
		scene_to_spawn = Tutorial
	elif main.difficulty <= .33:
		scene_to_spawn = EasyLayouts.pick_random()
	elif .33 < main.difficulty and main.difficulty < .66:
		scene_to_spawn = MedLayouts.pick_random()
	else:
		scene_to_spawn = HardLayouts.pick_random()
	
	var instance = scene_to_spawn.instantiate()
	add_child(instance)
