class_name MainMenuButton extends Button

enum HoverState{ CAN_BE_HOVERED, CANNOT_BE_HOVERED }

const INTRO_SEQUENCE_COOLDOWN : float = 0.3
const RAPID_TOGGLE_GATE_DURATION : float = 0.05

signal outro_finished

var outro_queued : bool = false ## flag set to true when outro has started
var outro_already_finished : bool = false ## flag set to true once outro has finished
var hover_state : HoverState = HoverState.CANNOT_BE_HOVERED

@export var intro : ControlTween
@export var outro : ControlTween
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
	
	# set self up with pos ratio set all the way left
	self.offset_transform_position_ratio = Vector2(-1, 0)


## This func plays the outro of any button passed into it, with the exception of
## the [param pressed_button] which handles its own pressed logic
static func outro_all_buttons(pressed_button : MainMenuButton, all_buttons : Array[MainMenuButton]) -> void:
	for button in all_buttons:
		if button == pressed_button:
			continue
		button.play_outro()
	
	for button in all_buttons:
		if button == pressed_button:
			continue
		if button.outro.tween == null:
			continue
		if !button.outro.tween.is_running():
			continue
		await button.outro.tween.finished
	
	if !pressed_button.outro_already_finished:
		await pressed_button.outro_finished


## This func plays the button's intros in sequence with a small delay. Because of this, 
## [param all_buttons] should have the buttons in the order you want them to intro in
static func intro_all_buttons(all_buttons : Array[MainMenuButton]) -> void:
	for button in all_buttons:
		# dont delay first button tween
		if button != all_buttons.get(0):
			# have to call get_tree() on button since this is a static func :)
			await button.get_tree().create_timer(INTRO_SEQUENCE_COOLDOWN).timeout
		button.play_intro()


## Checks if all the export vars are set properly
func tweens_are_valid() -> bool:
	if intro == null:
		printerr("%s: intro export var is null" % self)
		return false
	if outro == null:
		printerr("%s: outro export var is null" % self)
		return false
	if start_hover_effect == null:
		printerr("%s: start_hover_effect export var is null" % self)
		return false
	if end_hover_effect == null:
		printerr("%s: end_hover_effect export var is null" % self)
		return false
	if press_effect == null:
		printerr("%s: press_effect export var is null" % self)
		return false
	if release_effect == null:
		printerr("%s: release_effect export var is null" % self)
		return false
	
	return true


## Cancels any hover effects playing currently
func cancel_hover_tweens() -> void:
	if start_hover_effect.tween != null && start_hover_effect.tween.is_running():
		start_hover_effect.tween.kill()
	if end_hover_effect.tween != null && end_hover_effect.tween.is_running():
		end_hover_effect.tween.kill()


func play_intro() -> void:
	await intro.do_tween()
	hover_state = HoverState.CAN_BE_HOVERED


func play_hover_tween(tween : ControlTween) -> void:
	cancel_hover_tweens()
	hover_state = HoverState.CANNOT_BE_HOVERED
	tween.do_tween()
	# this looks fucked but it creates a small cooldown where the tweens cant 
	# rapidly toggle hover on -> hover off -> hover on
	await get_tree().create_timer(RAPID_TOGGLE_GATE_DURATION).timeout
	hover_state = HoverState.CAN_BE_HOVERED


func play_outro() -> void:
	if outro_queued:
		return
	hover_state = HoverState.CANNOT_BE_HOVERED
	outro_queued = true
	outro.do_tween()
	if outro.tween != null && outro.tween.is_running():
		await outro.tween.finished
	outro_finished.emit()
	outro_already_finished = true


#region signal connections

func _on_hover_begin() -> void:
	if hover_state == HoverState.CANNOT_BE_HOVERED || outro_queued:
		return
	play_hover_tween(start_hover_effect)


func _on_hover_end() -> void:
	if outro_queued:
		return
	play_hover_tween(end_hover_effect)


func _on_button_up() -> void:
	if outro_queued:
		return
	# kill press effect if one is playing
	if press_effect.tween != null: 
		press_effect.tween.kill()
	release_effect.do_tween()


## This purely handles playing the release_effect tween that plays on any kind of
## button press, holds no logic for handling the pressed event
func _on_button_down() -> void:
	if outro_queued:
		return
	hover_state = HoverState.CANNOT_BE_HOVERED
	# kill release effect if one is playing
	if release_effect.tween != null:
		release_effect.tween.kill()
	await press_effect.do_tween()


## Purely handles the logic for when the player successfully presses the button.
## no tween initiations aside from playing the outro
func _on_button_pressed() -> void:
	if outro_queued:
		return
	
	await release_effect.tween_finished
	
	play_outro()

#endregion
