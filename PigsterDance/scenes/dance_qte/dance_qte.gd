class_name DanceQte
extends Node2D

signal qte_won
signal qte_failed

@onready var hit_box: Area2D = $HitBox
@onready var key_handler: DanceKeyHandler = $KeyHandler
@onready var result_label: Label = $ResultLabel

var tries_left: int = 0
var is_qte_active: bool = false
var current_level_stats: DanceLevelStats


func _ready() -> void:
	key_handler.key_succeeded.connect(_on_key_succeeded)
	key_handler.key_failed.connect(_on_key_failed)
	key_handler.all_keys_succeeded.connect(_on_all_keys_succeeded)
	_qte_debug("Waiting For Input")


func start_qte() -> void:
	if current_level_stats.key_pool.is_empty():
		push_error("Key Pool is Empty")
		return
	
	tries_left = current_level_stats.max_tries
	_start_round()

func _start_round() -> void:
	is_qte_active = true
	_qte_debug("Waiting For Input")
	key_handler.start_round(current_level_stats, hit_box)


func _input(event: InputEvent) -> void:
	if not is_qte_active or not event.is_pressed() or event.is_echo():
		return

	key_handler.handle_input(event)


func _qte_debug(text: String) -> void:
	result_label.text = text


func _end_qte() -> void:
	is_qte_active = false
	key_handler.stop()


func _fail_qte(reason: String) -> void:
	_end_qte()
	key_handler.clear_keys()
	tries_left -= 1

	if tries_left <= 0:
		_qte_debug("%s - No tries left" % reason)
		qte_failed.emit()
		return

	_qte_debug("%s - %d tries left" % [reason, tries_left])
	await get_tree().create_timer(current_level_stats.retry_delay).timeout
	_start_round()


func _on_key_succeeded(_key: InputEvent) -> void:
	_qte_debug("SUCCESS")


func _on_key_failed(reason: String) -> void:
	_fail_qte(reason)


func _on_all_keys_succeeded() -> void:
	_end_qte()
	qte_won.emit()
