extends MicroGame

@export var level_scenes: Array[PackedScene] = []

@onready var current_level: Node = $CurrentLevel

var _level_queue: Array[PackedScene] = []

func _ready() -> void:
	difficulty = GameManager.difficulty_manager.current_difficulty
	
	_build_level_queue()
	_advance_to_next_level()

func _build_level_queue() -> void:
	_level_queue.assign(level_scenes)
	
	if not is_zero_approx(difficulty):
		_level_queue.shuffle()

func _advance_to_next_level() -> void:
	if _level_queue.is_empty():
		GameManager.win()
		return
	
	_load_level(_level_queue.pop_front())


func _load_level(level_scene: PackedScene) -> void:
	_clear_current_level()
	
	var level: Node2D = level_scene.instantiate()
	level.global_difficulty = difficulty
	current_level.add_child(level)
	level.level_completed.connect(_on_level_completed)
	level.level_failed.connect(_on_level_failed)


func _on_level_completed() -> void:
	_advance_to_next_level()


func _on_level_failed() -> void:
	GameManager.lose()


func _clear_current_level() -> void:
	for child in current_level.get_children():
		child.queue_free()
