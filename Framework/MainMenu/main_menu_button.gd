class_name MainMenuButton extends Button

enum HoverState{ CAN_BE_HOVERED, CANNOT_BE_HOVERED }

signal tween_out_finished

var tween_out_queued : bool = false ## flag set to true when tween_out has started
var tween_out_already_finished : bool = false
var hover_state : HoverState = HoverState.CANNOT_BE_HOVERED

## need this var because the tween doing the actual anim for the release effect gets recycled veryyyy
## quickly, so this is a sort of sentinal value that stores the most recently created one, and can be
## watched for when one of these tweens successfully finishes (denotes outro being queued)
var watched_release_tween : Tween

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
	self.button_down.connect(_on_button_down)
	self.button_up.connect(_on_button_up)
	self.pressed.connect(_on_button_pressed)
	
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


func cancel_hover_tweens() -> void:
	if start_hover_effect.tween != null && start_hover_effect.tween.is_running():
		start_hover_effect.tween.kill()
	if end_hover_effect.tween != null && end_hover_effect.tween.is_running():
		end_hover_effect.tween.kill()


func play_tween_in() -> void:
	await tween_in.do_tween()
	hover_state = HoverState.CAN_BE_HOVERED


func play_hover_tween(tween : ControlTween) -> void:
	cancel_hover_tweens()
	hover_state = HoverState.CANNOT_BE_HOVERED
	tween.do_tween()
	# this looks fucked but it creates a small cooldown where the tweens cant 
	# rapidly toggle hover on -> hover off -> hover on
	await get_tree().create_timer(0.05).timeout
	hover_state = HoverState.CAN_BE_HOVERED


func do_tween_out() -> void:
	if tween_out_queued:
		return
	hover_state = HoverState.CANNOT_BE_HOVERED
	tween_out_queued = true
	tween_out.do_tween()
	if tween_out.tween != null && tween_out.tween.is_running():
		await tween_out.tween.finished
	tween_out_finished.emit()
	tween_out_already_finished = true


func _on_hover_begin() -> void:
	if hover_state == HoverState.CANNOT_BE_HOVERED || tween_out_queued:
		return
	play_hover_tween(start_hover_effect)


func _on_hover_end() -> void:
	if tween_out_queued:
		return
	play_hover_tween(end_hover_effect)


func _on_button_down() -> void:
	if tween_out_queued:
		return
	hover_state = HoverState.CANNOT_BE_HOVERED
	if release_effect.tween != null:
		release_effect.tween.kill()
	await press_effect.do_tween()


func _on_button_up() -> void:
	if tween_out_queued:
		return
	if press_effect.tween != null: 
		press_effect.tween.kill()
	release_effect.do_tween()
	watched_release_tween = release_effect.tween


func _on_button_pressed() -> void:
	if tween_out_queued:
		return
	
	await get_tree().process_frame
	if watched_release_tween != null:
		await watched_release_tween.finished
	
	do_tween_out()
