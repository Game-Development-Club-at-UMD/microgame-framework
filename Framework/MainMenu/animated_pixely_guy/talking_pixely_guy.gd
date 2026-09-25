extends Node2D
@onready var _head = %PixelyGuyHead
@onready var _body = %PixelyGuyBody
@export var intro_delay: float = 0.6
@export var intro_duration: float = 0.4
@export var intro_distance: float = 600.0 #shift guy to off screen before sliding in
@onready var clickable_area: Area2D = $ClickableArea as Area2D

@onready var squish: ControlTween = $Control/Squish as ControlTween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_head.play("talking-head")
	_body.play("talking-body")
	
	var final_position: Vector2 = position #where we want guy to end up, 
	#move to offscreen right 				#is where he is set in mainmenu image
	position.x += intro_distance
	#wait for buttons
	await get_tree().create_timer(intro_delay).timeout
	#make tween to move guy
	var intro_tween: Tween = create_tween()
	#set tween, come in and rebound back a little
	intro_tween.set_ease(Tween.EASE_OUT)
	intro_tween.set_trans(Tween.TRANS_SPRING)
	
	#activate tween
	intro_tween.tween_property(self,"position",final_position,intro_duration)
	clickable_area.input_event.connect(clicked)

func clicked(_viewport : Node, event : InputEvent, _shape_inx : int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.is_pressed():
		squish.do_tween()
