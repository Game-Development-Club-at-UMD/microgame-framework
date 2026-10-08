extends RigidBody2D

var vel = linear_velocity
var damp: float = 0.1
var speed: int = 1000
var pressed = false
var pressed2 = false
var vector1: Vector2
signal lose
signal press
signal press2

func _ready() -> void:
	self.freeze = true
	gravity_scale = 5.0

func throw(angle, magnitude) -> void:
	var mag = Vector2(magnitude.x, magnitude.x)
	self.freeze = false
	if 0 <= angle and angle <= 45:
		vector1 = Vector2(cos(angle), sin(angle))
	elif -45 <= angle and angle <= 0:
		vector1 = Vector2(cos(angle), sin(angle))
	apply_impulse(mag*vector1)
	await get_tree().create_timer(1.75).timeout
	lose.emit()
	
func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") and !pressed:
		press.emit()
		pressed = true
	elif Input.is_action_just_pressed("ui_accept") and pressed and !pressed2:
		press2.emit()
