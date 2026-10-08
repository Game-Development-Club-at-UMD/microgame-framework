extends MicroGame

var baby = preload("res://BabyDefenestration/rigidbaby.tscn")
var window = preload("res://BabyDefenestration/window.tscn")
var timer_start: bool = false
var win: bool = false
var pressed : bool = false
var pressed2: bool = false
@onready var level1: Node = $"."
@onready var label : Label = $/root/Level1/Label
@onready var timer : Timer = $/root/Level1/Timer
@onready var playerArrow: Polygon2D = $/root/Level1/Player
@onready var guy: Sprite2D = $guy
@onready var babycry: AudioStreamPlayer2D = $babycry
@onready var baby1 = baby.instantiate()
@onready var babybody = baby1.get_node("RigidBody2D")

func _ready() -> void:
	$AnimationPlayer.play("babytutorial")
	await get_tree().create_timer(2).timeout
	var tween = get_tree().create_tween()
	tween.tween_property($tutorial, "self_modulate:a", 0, 1.0)
	babycry.play()
	var time_left = 15 - (10*GameManager.difficulty_manager.current_difficulty)
	playerArrow.position = Vector2(guy.position.x+20, guy.position.y-65); playerArrow.show()
	guy.frame = 0
	label.position = Vector2(20, 10)
	timer.wait_time = time_left
	timer.start()
	var scale_values = remap(GameManager.difficulty_manager.current_difficulty, 0.0, 1.0, 0.6, 0.3)
	var window1 = window.instantiate()
	var windowarea = window1.get_node("Window_Area")
	level1.add_child(baby1)
	level1.add_child(window1)
	windowarea.win.connect(_on_win)
	babybody.lose.connect(_on_lose)
	babybody.press.connect(_on_press)
	babybody.press2.connect(_on_press_2)
	#res://BabyDefenestration/level1.tscn
	baby1.position = playerArrow.position
	window1.position.x = 792; window1.position.y = randi_range(145, 503)
	window1.scale.y = scale_values

func _process(_delta):
	if timer.start:
		label.text = str(timer.get_time_left()).pad_decimals(2)
	if !pressed:
		playerArrow._launch_angle()
	if pressed and !pressed2:
		playerArrow._launch()
	if pressed2:
		guy.frame = 1
		babybody.throw(playerArrow.rotation, 4200*playerArrow.scale)
		playerArrow.hide()
		pressed2 = false
	
func _on_press() -> void:
	pressed = true

func _on_press_2() -> void:
	pressed2 = true

func _on_timer_timeout() -> void:
	print("Timed out!")
	if !win:
		print("You lost!")
		GameManager.lose()

func _on_win():
	win = true
	
func _on_lose():
	if !win:
		GameManager.lose()
