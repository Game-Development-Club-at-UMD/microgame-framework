extends Control

signal finished(success: bool)

@export var event_duration := 1.0
@export var display_duration := 1.0

@onready var circle = %Circle
@onready var success_label = %SuccessLabel
@onready var fail_label = %FailLabel
@onready var spacebar_texture = %SpacebarTexture
@onready var animation_player = $AnimationPlayer

var tween: Tween
var qte_activated: bool = false
var qte_pass: bool = false

func _ready() -> void:
	hide()
	set_process_input(false)


func start() -> void:
	success_label.hide()
	fail_label.hide()
	circle.material.set_shader_parameter("value", 1.0)
	
	qte_pass = false
	qte_activated = true
	show()
	set_process_input(true)
	
	_run_timer()

func _run_timer() -> void:
	if tween and tween.is_valid():
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(circle, "material:shader_parameter/value", 0.0, event_duration)
	animation_player.play("spacebar_animation")
	
	await tween.finished
	
	if qte_activated and not qte_pass:
		_on_fail()


func _input(event: InputEvent) -> void:
	if not qte_activated or qte_pass:
		return
	
	if event is InputEventKey and event.pressed and not event.is_echo() and event.keycode == KEY_SPACE:
		_on_success()

func _on_success() -> void:
	_resolve(true)
	success_label.show()


func _on_fail() -> void:
	_resolve(false)
	fail_label.show()


func _resolve(success: bool) -> void:
	qte_pass = true
	qte_activated = false
	set_process_input(false)
	
	if tween and tween.is_valid():
		tween.kill()
		
	finished.emit(success)

	await get_tree().create_timer(display_duration, false).timeout
	hide()
