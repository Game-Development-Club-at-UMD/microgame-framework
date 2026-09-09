class_name MainMenuButton extends Button

enum State{}

@export var tween_in : ControlTween
@export var tween_out : ControlTween
@export var start_hover_effect : ControlTween
@export var end_hover_effect : ControlTween

func _ready() -> void:
	if !tweens_are_valid():
		return
	
	tween_in.do_tween()


func tweens_are_valid() -> bool:
	if tween_in == null:
		printerr("%s: tween_in export var is null")
		return false
	if tween_out == null:
		printerr("%s: tween_out export var is null")
		return false
	if start_hover_effect == null:
		printerr("%s: start_hover_effect export var is null")
		return false
	if end_hover_effect == null:
		printerr("%s: end_hover_effect export var is null")
		return false
	
	return true
