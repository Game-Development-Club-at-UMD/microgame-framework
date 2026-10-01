extends MicroGame

@onready var level1: Node = $"."
var baby = preload("res://BabyDefenestration/rigidbaby.tscn")

func _ready() -> void:
	var baby1 = baby.instantiate()
	level1.add_child(baby1)
	#Position of baby will line up with player controller eventaully
	baby1.position.x = 300; baby1.position.y = 350
