class_name QteKey
extends Sprite2D

signal key_press_finished(key: QteKey, is_success: bool)

enum State { PENDING, SUCCESS, FAILED }
const DESPAWN_X_LOCATION := -128.0

@export var icon_set: QteKeyIconSet

@onready var label: Label = $Label

var key: InputEvent
var speed: float = 300.0
var state: State = State.PENDING
var is_key_in_box: bool = false

var icon: QteKeyIcon

func _process(delta: float) -> void:
	global_position.x -= speed * delta
	if global_position.x < DESPAWN_X_LOCATION:
		queue_free()

func _change_state(new_state: State) -> void:
	if not is_state_pending():
		return
	state = new_state
	_update_visuals()  
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
	icon = icon_set.get_icon(_get_keycode(key))
	_update_visuals()

func is_key_matching(event: InputEvent) -> bool:
	return key.is_match(event, false)


func _get_keycode(event: InputEventKey) -> Key:
	if event.keycode != KEY_NONE:
		return event.keycode
	var localized := DisplayServer.keyboard_get_keycode_from_physical(event.physical_keycode)
	return localized if localized != KEY_NONE else event.physical_keycode


func _update_visuals() -> void:
	if icon:
		var icon_texture := icon.filled if state == State.SUCCESS else icon.outline
		texture = icon_texture
		label.visible = false
	else:
		label.visible = true
		label.text = key.as_text().replace("", "")
