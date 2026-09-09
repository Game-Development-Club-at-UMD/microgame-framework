@icon("res://ExampleGame/Bubble/Assets/Bubble.png")
class_name Bubble extends Node2D

@onready var area_2d: Area2D = $Area2D
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@onready var shrink: Node2DTween = $Shrink as Node2DTween
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@warning_ignore('unused_signal') signal bubble_popped


func _ready() -> void:
	area_2d.mouse_entered.connect(pop_bubble)


func pop_bubble() -> void:
	area_2d.input_pickable = false
	audio_stream_player.play()
	cpu_particles_2d.emitting = true
	if shrink : shrink.do_tween()
	await cpu_particles_2d.finished
	if audio_stream_player.playing:
		await audio_stream_player.finished
	queue_free()
