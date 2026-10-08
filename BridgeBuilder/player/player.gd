extends CharacterBody2D

const SPEED = 175.0
const JUMP_VELOCITY = -250.0
var moving : bool = false

func _on_timer_timeout() -> void:
	moving = true

func _physics_process(delta: float) -> void:
	if moving:
		velocity.x = SPEED
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	move_and_slide()
