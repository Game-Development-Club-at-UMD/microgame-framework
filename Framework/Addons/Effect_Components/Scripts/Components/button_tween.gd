@tool
class_name ButtonEffect extends ControlTween
## [ButtonEffect] is an extension of [ControlTween] designed to be used for buttons

@export_enum(
			'On Mouse Enter and Exit',
			'On Mouse Enter',
			'On Mouse Exit',
			'On Mouse Pressed',
			'On Button Down and Button Up',
			'On Button Down',
			'On Button Up'
			) var button_effect_type = 0

## Call parent _ready() function and only run if the class is in fact a button
func _ready() -> void:
	if affected_node is BaseButton:
		super()
		setup_button_signal()
	else:
		printerr(self, 'Affected node is not a button class, ignoring effect setup')


func setup_button_signal() -> void:
	match button_effect_type:
		0:
			affected_node.mouse_entered.connect(do_tween)
			affected_node.mouse_exited.connect(do_tween.bind(false))
		1:
			affected_node.mouse_entered.connect(do_tween)
		2:
			affected_node.mouse_exited.connect(do_tween)
		3:
			(affected_node as BaseButton).pressed.connect(do_tween)
		4:
			(affected_node as BaseButton).button_down.connect(do_tween)
			(affected_node as BaseButton).button_up.connect(do_tween.bind(false))
		5:
			(affected_node as BaseButton).button_down.connect(do_tween)
		6:
			(affected_node as BaseButton).button_up.connect(do_tween)
