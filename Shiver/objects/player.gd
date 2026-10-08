extends CharacterBody3D

@export var campfire: Node

@onready var shiver_anim = $"Shiverer"
@onready var camera_pivot = $"Camera Pivot"
@onready var camera = $"Camera Pivot/Camera3D"
@onready var log_pickup_area = $"Camera Pivot/Log Pickup Area"
## Where you hold the log when you pick it up.
@onready var log_hold_position = $"Camera Pivot/Log Hold Position"

# SFX
@onready var sfx_snow_trudge: AudioStreamPlayer = $SfxSnowTrudge
@onready var sfx_humph_grab: AudioStreamPlayer = $SfxHumphGrab
@onready var sfx_huwah_throw: AudioStreamPlayer = $SfxHuwahThrow

@onready var instruction_text = $"TooltipLayer/Control/MarginContainer/RichTextLabel"
@onready var lose_anim: AnimationPlayer = $"LoseAnim"

var game: Node3D

var all_held_logs: Array[RigidBody3D] = []

const THROW_STRENGTH = 50.0

const MOUSE_SENSITIVITY = 0.0025

const GRAV = -40.0
const GROUND_ACCEL = 60.0
const MAX_SPEED = 10.0
## Speed multiplier when holding firewood.
const LOG_SPEED_MULT = 0.5

## Only changes when the game loses for cosmetic purposes. Exported so the AnimationPlayer can edit it directly.
@export var freeze_speed_multiplier: float = 1.0

# the number of projects I have made where the y velocity is overriden manually every frame is truly ridiculous
var current_grav = 0.0

## Used to start the game when the player starts moving.
signal player_started_game

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		var camera_movement: Vector2
		camera_movement = event.screen_relative * -MOUSE_SENSITIVITY
		camera_pivot.rotation.x = clamp(camera_pivot.rotation.x + camera_movement.y, -PI / 2, PI / 2)
		camera_pivot.rotate_y(camera_movement.x)

func _ready() -> void:
	game = get_parent()
	shiver_anim.play("shiver")

func _physics_process(delta: float) -> void:
	if not game.started:
		velocity.y = -20
		move_and_slide()
		var super_raw_input_dir = Input.get_vector("a", "d", "s", "w")
		if super_raw_input_dir:
			emit_signal("player_started_game")
			#instruction_text.set_text("[center]Use logs to feed the fire!")
		return
	
	# *** Camera movement ***
	var cam_rot = camera_pivot.global_rotation.y
	if campfire.temp > 0.5:
		shiver_anim.speed_scale = 0
	else:
		shiver_anim.speed_scale = 1
	
	# input for picking up/throwing log
	if Input.is_action_just_pressed("left_click") or Input.is_action_just_pressed("space") or Input.is_action_just_pressed("right_click"):
		# true when you aren't holding any logs
		if all_held_logs.is_empty():
			# only runs if you have logs to pick up
			if !(log_pickup_area.all_bodies_inside_me.is_empty()):
				# picks up all logs
				for firewood in log_pickup_area.all_bodies_inside_me:
					firewood.stop_working()
					all_held_logs.append(firewood)
				
				# grab sfx, starts delayed because of dead noise
				sfx_humph_grab.play(0.33)
				instruction_text.set_text("[center](Click) Roll")
		# otherwise, you need to throw the logs
		else:
			for firewood in all_held_logs:
				firewood.start_working()
				firewood.launch_with_velocity(THROW_STRENGTH * -camera_pivot.global_transform.basis.z.normalized())
			all_held_logs.clear()
			
			instruction_text.set_text("")
			# play throw sfx, starts delayed because of dead noise
			sfx_huwah_throw.play(0.5)
	
	# *** Jumping and gravity ***
	if is_on_floor():
		current_grav = 0.0
	elif is_on_ceiling() and current_grav > 0:
		current_grav = 0
	else:
		current_grav += GRAV * delta
	
	# *** Horizontal movement ***
	var raw_input_dir = Input.get_vector("a", "d", "s", "w")
	
	# modified by raw_input based on camera rotation
	var cooked_input_dir = Vector3.ZERO
	
	# forward and back
	cooked_input_dir.z -= raw_input_dir.y * cos(cam_rot)
	cooked_input_dir.x -= raw_input_dir.y * sin(cam_rot)
	# left and right
	cooked_input_dir.z -= raw_input_dir.x * sin(cam_rot)
	cooked_input_dir.x += raw_input_dir.x * cos(cam_rot)
	
	var speed_mult: float = freeze_speed_multiplier
	if !all_held_logs.is_empty():
		speed_mult *= LOG_SPEED_MULT
	velocity = velocity.move_toward(cooked_input_dir * MAX_SPEED * speed_mult, GROUND_ACCEL * delta * speed_mult)
	velocity.y = current_grav
	
	# plays walking sfx if the player is moving
	if velocity.x != 0 or velocity.z != 0:
		if not sfx_snow_trudge.playing:
			sfx_snow_trudge.play(randi_range(0,9))
	else:
		sfx_snow_trudge.stop()
	
	move_and_slide()
	
	if !all_held_logs.is_empty():
		for firewood in all_held_logs:
			firewood.position = log_hold_position.global_position
			firewood.rotation = Vector3(camera_pivot.rotation.x, camera_pivot.rotation.y, camera_pivot.rotation.z - PI/2)

func lose_and_freeze_and_be_generally_sad() -> void:
	lose_anim.play("lose")
