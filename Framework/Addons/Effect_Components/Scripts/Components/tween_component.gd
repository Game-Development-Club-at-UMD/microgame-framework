@tool
@abstract
class_name TweenComponent extends Node
## The TweenComponent class is an abstract class meant to be used to build out other
## tween component classes. [br]
## This class contains all of the information relating to the tween including
## transitions, easing, and the tween's duration.


@export_category("Universal Parameters")
## Determines if the effect will loop while playing.
@export var loop : bool = false

## Starts the effect upon the node becoming ready
@export var autostart : bool = false

@export_category("Transition Parameters")
## Toggles if the [transition_curve] should be used as the transition type
@export var use_custom_curve : bool = false:
	set(value):
		use_custom_curve = value
		update_configuration_warnings()
		notify_property_list_changed()
## The custom curve transition
@export var transition_curve : Curve:
	set(value):
		transition_curve = value
		update_configuration_warnings()
## Type of [TransitionType] of the tween.
@export var trans_type : Tween.TransitionType
## Type of [EaseType] of the tween.
@export var ease_type : Tween.EaseType
## Duration of the tween as a [float].
@export var tween_duration : float = 1.0


## The variable holding the tween.
var tween : Tween


func _get_configuration_warnings() -> PackedStringArray:
	var warnings : PackedStringArray = []
	
	if use_custom_curve:
		if transition_curve == null:
			warnings.append("No transition curve!")
		if transition_curve != null and transition_curve.get_point_position(0) != Vector2(0.0, 0.0):
			warnings.append("Curve's first point needs to start at (0.0, 0.0)!")
		if transition_curve != null and transition_curve.get_point_position(transition_curve.point_count - 1) != Vector2(1.0, 1.0):
			warnings.append("Curve's last point needs to end at (1.0, 1.0)!")
	#TODO: update warning when changing points value
	return warnings



func _validate_property(property: Dictionary) -> void:
	if not use_custom_curve:
		match property.name:
			"transition_curve":
				property.usage &= ~PROPERTY_USAGE_EDITOR
	else:
		match property.name:
			"trans_type":
				property.usage &= ~PROPERTY_USAGE_EDITOR
				trans_type = Tween.TransitionType.TRANS_LINEAR
			"ease_type":
				property.usage &= ~PROPERTY_USAGE_EDITOR
				ease_type = Tween.EaseType.EASE_IN



func _ready() -> void:
	# Check if the custom curve is used and if the curve is valid.
	if use_custom_curve and curve_is_valid():
		# Bake the curve once at the beginning so it's more performant when sampling
		transition_curve.bake()


## This function resets and creates a new tween with all given parameters:
## [member trans_type], [member ease_type].
func _reset_tween() -> void:
	# If there is a current tween, abort it
	if tween:
		tween.kill()
	# Setup the new tween
	_setup_tween()


## Creates the tween with the [member ease_type], [member trans_type] and
## allow for tweening to be done simultaneously.
func _setup_tween() -> void:
	tween = create_tween().set_ease(ease_type).set_trans(trans_type).set_parallel(true)


## Kill the [member tween] if a [member tween] exists
func _stop_tween() -> void:
	if tween:
		tween.kill()


## Kill a tween if it is empty to prevent giving an error.
func _kill_empty_tween() -> void:
	if !tween.has_tweeners():
		_stop_tween()


## Returns if a curve is valid. [br]
## A curve is valid of it has points at the min and max of the curve, so the whole curve can be traversed.
func curve_is_valid() -> bool:
	# Is there ever a damn curve
	if !transition_curve:
		printerr("%s: No curve assigned to %s, and attempted to run." % [self, self.name])
		return false
	# Check if the first point is at the min of the curve
	if transition_curve.get_point_position(0) != Vector2(0.0, 0.0):
		printerr("%s: Tween Curve first point is not (0.0, 0.0) %s" % [self, self.name])
		return false
	# Check if the last point is at the max of the curve
	if transition_curve.get_point_position(transition_curve.point_count - 1) != Vector2(1.0, 1.0):
		printerr("%s: Tween Curve last point is not (1.0, 1.0) %s" % [self, self.name])
		return false
	
	return true


@abstract func do_tween(forward : bool = true) -> void

@abstract func _tween_values(forward : bool = true) -> void

@abstract func set_current_values() -> void

@abstract func has_errors() -> bool
