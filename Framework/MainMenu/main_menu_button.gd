class_name MainMenuButton extends Button

enum HoverState{ CAN_BE_HOVERED, CANNOT_BE_HOVERED }

var hover_state : HoverState = HoverState.CANNOT_BE_HOVERED:
	set(value):
		if value == HoverState.CAN_BE_HOVERED:
			hover_state = value
			return
		if tween_out == null:
			return
		hover_state = HoverState.CANNOT_BE_HOVERED
		await await_all_tweens_finished()
		tween_out.do_tween()


@export var tween_in : ControlTween
@export var tween_out : ControlTween
@export var start_hover_effect : ControlTween
@export var end_hover_effect : ControlTween


func _ready() -> void:
	if !tweens_are_valid():
		return
	
	# connect mouse entered/exit funcs
	self.mouse_entered.connect(_on_mouse_state_changed.bind(true))
	self.mouse_exited.connect(_on_mouse_state_changed.bind(false))
	
	# do starter tween
	self.pivot_offset = Vector2(-500, 0)
	tween_in.do_tween()
	await tween_in.tween.finished
	hover_state = HoverState.CAN_BE_HOVERED


func tweens_are_valid() -> bool:
	if tween_in == null:
		printerr("%s: tween_in export var is null" % self)
		return false
	if tween_out == null:
		printerr("%s: tween_out export var is null" % self)
		return false
	if start_hover_effect == null:
		printerr("%s: start_hover_effect export var is null" % self)
		return false
	if end_hover_effect == null:
		printerr("%s: end_hover_effect export var is null" % self)
		return false
	
	return true


func await_all_tweens_finished() -> void:
	if tween_in.tween.is_running():
		await tween_in.finished
	if tween_out.tween.is_running():
		await tween_out.finished
	if start_hover_effect.tween.is_running():
		await start_hover_effect.finished
	if end_hover_effect.tween.is_running():
		await end_hover_effect.finished


func _on_mouse_state_changed(has_mouse : bool) -> void:
	if hover_state == HoverState.CANNOT_BE_HOVERED:
		return
	
	await await_all_tweens_finished()
	
	var tween_to_play : ControlTween
	
	match has_mouse:
		true:
			tween_to_play = start_hover_effect
		false:
			tween_to_play = end_hover_effect
	
	hover_state = HoverState.CANNOT_BE_HOVERED
	tween_to_play.do_tween()
	await tween_to_play.tween.finished
	hover_state = HoverState.CAN_BE_HOVERED
