extends CharacterBody3D

## Used to determine how fast temperature drains. In the easiest difficulties, temperature decreases at half speed.
@export var game: MicroGame

@onready var sfx_fire_grow: AudioStreamPlayer = $SfxFireGrow

@onready var light = $"OmniLight3D"
@onready var burst_particles = $"BurstParticles"
@onready var sprite_pivot = $"Visual Campfire/Sprite Scale Pivot"
@onready var anim = $"AnimationPlayer"

const GRAVITY = -10.0

var temp: float = 1.0
## When 0.1, takes 10 seconds to fully deplete temperature.
var temp_loss_multiplier: float = 0.1

const MAX_RANGE = 200.0
const MAX_ENERGY = 15.0

const ENERGY_FROM_FIREWOOD = 0.5

func _ready() -> void:
	anim.play("burn_loop")
	if game.difficulty > 0.1:
		temp_loss_multiplier = 0.1
	else:
		temp_loss_multiplier = 0.05

signal fire_gone_out
var game_started : bool = false

func _process(delta: float) -> void:
	if not game_started:
		return
	
	temp = move_toward(temp, 0, delta * temp_loss_multiplier)
	update_visible_temperature()
	
	if temp <= 0:
		fire_gone_out.emit()
		game_started = false

func _physics_process(_delta: float) -> void:
	if !is_on_floor():
		velocity.y += GRAVITY
	else:
		velocity.y = 0
	move_and_slide()

## Eat the log.
func _on_area_3d_body_entered(body: Node3D) -> void:
	if not game_started:
		return
	
	if body is RigidBody3D:
		burst_particles.emitting = true
		body.queue_free()
		temp = clamp(temp + ENERGY_FROM_FIREWOOD, 0, 1)
		
		# sfx play for when log is added to fire successfully
		sfx_fire_grow.play()

func update_visible_temperature() -> void:
	light.omni_range = MAX_RANGE * temp
	light.light_energy = MAX_ENERGY * temp
	var new_scale = max(0.01, temp * 2)
	sprite_pivot.scale = Vector3(new_scale, new_scale, new_scale)

func _on_visibility_changed() -> void:
	game_started = true

func stop_shrinking() -> void:
	temp = 1
	update_visible_temperature()
	game_started = false
