@tool
class_name CanvasItemTween extends TweenResource

#region CanvasItem Properties
@export_group("Visibility")

## The modulate the node will start at, if WHITE then will set to default. [br]
## If both modulate are the same, the tween will ignore modulation
@export var start_modulate : Color = Color.WHITE

## The modulate the node will end at, if WHITE then will set to default. [br]
## If both modulate are the same, the tween will ignore modulation
@export var end_modulate : Color = Color.WHITE

var current_modulate : Color

## The value the modulate is reset to in the editor
var reset_modulate : Color
#endregion

## Call to tween each of the individual canvas item properties (modulate)
func tween_properties(tween : Tween, tween_duration : float, _affected_node : Node, forward : bool = true) -> void:
	_tween_modulate(tween, tween_duration, _affected_node, forward)


## Call to tween each of the individual canvas item properties (modulate) with a custom transition curve
func custom_tween_properties(tween : Tween, tween_duration : float, _affected_node : Node, curve : Curve, forward : bool = true) -> void:
	_custom_tween_modulate(tween, tween_duration, _affected_node, curve, forward)


## NOTE: ONLY TO BE USED IN THE EDITOR
func _reset_values(_affected_node : CanvasItem) -> void:
	if reset_modulate == null:
		printerr("%s: Some reset value in %s, was not set." % [_affected_node.name, self.get_class()])
		return
	
	_affected_node.modulate = reset_modulate


#region Canvas Item Functions
func _tween_modulate(tween : Tween, tween_duration : float, _affected_node : Node, forward : bool = true) -> void:
	# Tween modulate if start_modulate and end_modulate are not the same
	if start_modulate != end_modulate:
		tween.tween_property(
			_affected_node,
			"modulate",
			end_modulate if forward else start_modulate,
			tween_duration
		).from(
			start_modulate if forward else end_modulate
		)
#endregion

#region Custom Canvas Item Functions
func _custom_tween_modulate(tween : Tween, tween_duration : float, _affected_node : Node, curve : Curve, forward : bool = true) -> void:
	# Set the starting from -> this exists because MethodTweener does not have the .from() function
	var starting_mod : Color = start_modulate if forward else end_modulate
	(_affected_node as Control).modulate = starting_mod
	
	# Tween along the curve and lerp towards the sampled point
	tween.tween_method(
		func (progress : float): # DON'T WORRY ABOUT IT JUST PASSES IN PROGRESS -> PROGRESS IS A NUMBER FROM THE MIN TO MAX VALUES
			var curve_progress : float = curve.sample_baked(progress)
			var target_mod : Color = end_modulate if forward else start_modulate
			(_affected_node as Control).modulate = start_modulate.lerp(target_mod, curve_progress)
			,
		curve.min_domain,
		curve.max_domain,
		tween_duration
	)
#endregion


## Set the current canvas item values when the tween is run
func set_current_values(_affected_node : CanvasItem) -> void:
	current_modulate = _affected_node.modulate


## NOTE: ONLY TO BE USED IN THE EDITOR
func _set_reset_values(_affected_node : CanvasItem) -> void:
	reset_modulate = _affected_node.modulate
