extends RigidBody2D

var is_dragging: bool = false
var mouse_offset: Vector2 = Vector2.ZERO

func _ready() -> void:
	freeze = true

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			is_dragging = true
			# Freeze physics so the body doesn't fall or react to gravity while dragged
			freeze = true
			mouse_offset = global_position - get_global_mouse_position()
		else:
			drop()

func _physics_process(delta: float):
	if is_dragging:
		# Smoothly pull the object toward the mouse position plus the offset
		global_position = get_global_mouse_position() + mouse_offset

func drop():
	if is_dragging:
		is_dragging = false
		# Unfreeze physics so it falls and interacts normally again
		freeze = false
