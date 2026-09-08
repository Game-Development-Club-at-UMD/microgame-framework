class_name BubbleGame extends Node2D

var bubble_count : int = 0

@warning_ignore("unused_signal") signal switch_to_new_scene
@warning_ignore("unused_signal") signal reload_scene

func _ready() -> void:
	add_all_bubble_signals()

func add_all_bubble_signals() -> void:
	for child in get_children():
		if child is ParticlePathing:
			(child as ParticlePathing).decrease_bubble_count.connect(decrease_bubble_count)
			(child as ParticlePathing).evil_bubble_clicked.connect(_on_evil_bubble_clicked)


func increase_bubble_count():
	bubble_count += 1


func decrease_bubble_count():
	bubble_count -= 1
	check_for_game_completion()


func _on_evil_bubble_clicked():
	reload_scene.emit()

func check_for_game_completion() -> void:
	if bubble_count == 0:
		switch_to_new_scene.emit()
