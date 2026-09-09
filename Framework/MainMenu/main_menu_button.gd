class_name MainMenuButton extends Button

enum HoverState{ CAN_BE_HOVERED, CANNOT_BE_HOVERED }


var ready_to_quit : bool = false ## flag set to true when tween_out has finished
var quit_queued : bool = false ## flag set to true when tween_out has started
var hover_state : HoverState = HoverState.CANNOT_BE_HOVERED

@export var tween_in : ControlTween
@export var tween_out : ControlTween
@export var start_hover_effect : ControlTween
@export var end_hover_effect : ControlTween
@export var press_effect : ControlTween
@export var release_effect : ControlTween


func _ready() -> void:
	if !tweens_are_valid():
		return
	
	# connect mouse entered/exit funcs
	self.mouse_entered.connect(_on_hover_begin)
	self.mouse_exited.connect(_on_hover_end)
	self.button_down.connect(_on_pressed)
	self.button_up.connect(_on_released)
	
	self.offset_transform_position_ratio = Vector2(-1, 0)


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


func cancel_all_tweens() -> void:
	if tween_in.tween != null && tween_in.tween.is_running():
		tween_in.tween.kill()
	if tween_out.tween != null && tween_out.tween.is_running():
		tween_out.tween.kill()
	if start_hover_effect.tween != null && start_hover_effect.tween.is_running():
		start_hover_effect.tween.kill()
	if end_hover_effect.tween != null && end_hover_effect.tween.is_running():
		end_hover_effect.tween.kill()


func play_tween_in() -> void:
	tween_in.do_tween()
	await tween_in.tween.finished
	hover_state = HoverState.CAN_BE_HOVERED


func play_hover_tween(tween : ControlTween) -> void:
	cancel_all_tweens()
	hover_state = HoverState.CANNOT_BE_HOVERED
	tween.do_tween()
	# this looks fucked but it creates a small cooldown where the tweens cant 
	# rapidly toggle hover on -> hover off -> hover on
	await get_tree().create_timer(0.05).timeout
	hover_state = HoverState.CAN_BE_HOVERED


func do_tween_out() -> void:
	if quit_queued:
		return
	hover_state = HoverState.CANNOT_BE_HOVERED
	quit_queued = true
	cancel_all_tweens()
	tween_out.do_tween()
	await tween_out.tween.finished
	ready_to_quit = true


func _on_hover_begin() -> void:
	if hover_state == HoverState.CANNOT_BE_HOVERED || quit_queued:
		return
	play_hover_tween(start_hover_effect)


func _on_hover_end() -> void:
	if quit_queued:
		return
	play_hover_tween(end_hover_effect)


func _on_pressed() -> void:
	hover_state = HoverState.CANNOT_BE_HOVERED
	if release_effect.tween != null: release_effect.tween.kill()
	press_effect.do_tween()


func _on_released() -> void:
	if press_effect.tween != null: press_effect.tween.kill()
	release_effect.do_tween()
