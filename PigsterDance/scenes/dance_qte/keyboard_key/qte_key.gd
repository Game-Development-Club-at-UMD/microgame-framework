class_name QteKey
extends Sprite2D

signal key_press_finished(key: QteKey, is_success: bool)

enum State { PENDING, SUCCESS, FAILED }

@onready var label: Label = $Label

var key: InputEvent
var speed: float = 300.0
var state: State = State.PENDING
var is_key_in_box: bool = false


func _physics_process(delta: float) -> void:
	global_position.x -= speed * delta


func _change_state(new_state: State) -> void:
	if not is_state_pending():
		return
	state = new_state
	key_press_finished.emit(self, new_state == State.SUCCESS)


func is_state_pending() -> bool:
	return state == State.PENDING


func success_state() -> void:
	_change_state(State.SUCCESS)


func fail_state() -> void:
	_change_state(State.FAILED)

func is_on_screen() -> bool:
	return get_viewport_rect().has_point(global_position)

func set_key(new_key: InputEvent, new_speed: float) -> void:
	key = new_key
	speed = new_speed
	label.text = key.as_text() 


func is_key_matching(event: InputEvent) -> bool:
	return key.is_match(event, false)
