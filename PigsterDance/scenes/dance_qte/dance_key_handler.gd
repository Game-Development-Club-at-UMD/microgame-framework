class_name DanceKeyHandler
extends Node2D

signal key_succeeded(key: InputEvent)
signal key_failed(reason: String)
signal all_keys_succeeded

@export var spawn_offset: float = 64.0

@onready var spawn_timer: Timer = $SpawnTimer

var remaining_keys: Array[InputEvent] = []
var level_stats: DanceLevelStats
var hit_box: Area2D
var is_active: bool = false


func start_round(stats: DanceLevelStats, new_hit_box: Area2D) -> void:
	level_stats = stats
	hit_box = new_hit_box
	remaining_keys.assign(level_stats.key_pool)
	remaining_keys.shuffle()
	is_active = true
	start_spawn_timer()


func stop() -> void:
	is_active = false
	stop_spawn_timer()


func start_spawn_timer() -> void:
	spawn_timer.start(1)


func stop_spawn_timer() -> void:
	spawn_timer.stop()


func _on_spawn_timer_timeout() -> void:
	_spawn_key()
	if remaining_keys.is_empty():
		stop_spawn_timer()
	else:
		start_spawn_timer()


func _spawn_key() -> void:
	if remaining_keys.is_empty():
		return
	if level_stats.key_visuals == null:
		push_error("Key Scene is empty")
		return

	var key: QteKey = level_stats.key_visuals.instantiate()
	add_child(key)
	key.global_position = Vector2(get_viewport_rect().end.x + spawn_offset, hit_box.global_position.y)
	key.set_key(remaining_keys.pop_front(), level_stats.key_speed)
	key.key_press_finished.connect(_on_key_press_finished)


func _on_key_press_finished(key: QteKey, success: bool) -> void:
	if not is_active:
		return
	if not success:
		key_failed.emit("TOO LATE!")
		return

	key_succeeded.emit(key.key)

	if remaining_keys.is_empty() and not _has_pending_keys():
		all_keys_succeeded.emit()


func handle_input(event: InputEvent) -> void:
	if not is_active:
		return

	var closest_key := _find_closest_key()

	if closest_key == null:
		return

	if not closest_key.is_key_in_box:
		key_failed.emit("TOO EARLY!")
	elif closest_key.is_key_matching(event):
		closest_key.success_state()


func _find_closest_key() -> QteKey:
	var closest_key: QteKey = null

	for child in get_children():
		var key := child as QteKey
		if key == null or not key.is_state_pending() or not key.is_on_screen():
			continue
		if closest_key == null or key.global_position.x < closest_key.global_position.x:
			closest_key = key
	return closest_key


func _has_pending_keys() -> bool:
	for child in get_children():
		var key := child as QteKey
		if key != null and key.is_state_pending():
			return true
	return false


func clear_keys() -> void:
	for child in get_children():
		if child is QteKey:
			child.queue_free()
