@tool
class_name OffsetTransformTween extends TweenResource


#region Offset Transform Properties
@export_category("Offset Transform Properties")

@export_group("Offset Position")
## The position the tween will start at. [br]
## Has INF values by default, and will ignore individual x or y if left unchanged.
@export var start_offset_position : Vector2 = Vector2.INF

## The position the tween will end at. [br]
## Has INF values by default, and will ignore individual x or y if left unchanged.
@export var end_offset_position : Vector2 = Vector2.INF

## The current position of the node, stored in a variable
var current_offset_position : Vector2

@export_group("Offset Rotation")

## The rotation amount is the rotation degrees the tween will start at. [br]
## Has INF value by default, and will ignore this parameter if unchanged.
@export var start_offset_rotation : float = INF

## The rotation amount is the rotation degrees the tween will end at. [br]
## Has INF value by default, and will ignore this parameter if unchanged.
@export var end_offset_rotation : float = INF

## The current rotate of the node in rotation_degrees, stored in a variable
var current_offset_rotation : float

@export_group("Offset Scale")

## The scale amount is the scale the tween will start at. [br]
## Has INF values by default, and will ignore individual x or y if left unchanged.
@export var start_offset_scale : Vector2 = Vector2.INF

## The scale amount is the scale the tween will end at. [br]
## Has INF values by default, and will ignore individual x or y if left unchanged.
@export var end_offset_scale : Vector2 = Vector2.INF

## The current rotate of the node in rotation_degrees, stored in a variable
var current_offset_scale : Vector2


@export var start_offset_position_ratio : Vector2 = Vector2.INF


@export var end_offset_position_ratio : Vector2 = Vector2.INF


var current_offset_position_ratio : Vector2


## The value the offset position is reset to in the editor
var reset_offset_position : Vector2
## The value the offset rotation is reset to in the editor
var reset_offset_rotation : float
## The value the offset scale is reset to in the editor
var reset_offset_scale : Vector2
## The value the offset position ratio is reset to in the editor
var reset_offset_position_ratio : Vector2
#endregion


## Call to tween each of the individual offset transform properties (position, rotation, scale)
func tween_properties(tween : Tween, tween_duration : float, _affected_node : Node, forward : bool = true) -> void:
	_tween_offset_position(tween, tween_duration, _affected_node, forward)
	_tween_offset_rotation(tween, tween_duration, _affected_node, forward)
	_tween_offset_scale(tween, tween_duration, _affected_node, forward)
	_tween_offset_position_ratio(tween, tween_duration, _affected_node, forward)


## Call to tween each of the individual offset transform properties (position, rotation, scale) with a custom transition curve
func custom_tween_properties(tween : Tween, tween_duration : float, _affected_node : Node, curve : Curve, forward : bool = true) -> void:
	_custom_tween_offset_position(tween, tween_duration, _affected_node, curve, forward)
	_custom_tween_offset_rotation(tween, tween_duration, _affected_node, curve, forward)
	_custom_tween_offset_scale(tween, tween_duration, _affected_node, curve, forward)
	_custom_tween_offset_position_ratio(tween, tween_duration, _affected_node, curve, forward)


## NOTE: ONLY TO BE USED IN THE EDITOR
func _reset_values(_affected_node : Node) -> void:
	if reset_offset_position == null or reset_offset_rotation  == null or reset_offset_scale  == null or reset_offset_position_ratio == null:
		printerr("%s: Some reset value in %s, was not set." % [_affected_node.name, self.get_class()])
		return
	
	(_affected_node as Control).offset_transform_position = reset_offset_position
	(_affected_node as Control).offset_transform_rotation = reset_offset_rotation
	(_affected_node as Control).offset_transform_scale = reset_offset_scale
	(_affected_node as Control).offset_transform_position_ratio = reset_offset_position_ratio


#region Offset Transform Functions
func _tween_offset_position(tween : Tween, tween_duration : float, _affected_node : Node, forward : bool = true) -> void:
	if start_offset_position == end_offset_position: return
	# Tween position.x
	tween.tween_property(
		_affected_node,
		"offset_transform_position:x",
		(end_offset_position.x if end_offset_position.x != INF else current_offset_position.x) if forward else (start_offset_position.x if start_offset_position.x != INF else current_offset_position.x),
		tween_duration
		).from(
			(start_offset_position.x if start_offset_position.x != INF else current_offset_position.x) if forward else (end_offset_position.x if end_offset_position.x != INF else current_offset_position.x)
			)
	
	# Tween position.y
	tween.tween_property(
		_affected_node,
		"offset_transform_position:y",
		(end_offset_position.y if end_offset_position.y != INF else current_offset_position.y) if forward else (start_offset_position.y if start_offset_position.y != INF else current_offset_position.y),
		tween_duration
		).from(
			(start_offset_position.y if start_offset_position.y != INF else current_offset_position.y) if forward else (end_offset_position.y if end_offset_position.y != INF else current_offset_position.y)
			)


func _tween_offset_rotation(tween : Tween, tween_duration : float, _affected_node : Node, forward : bool = true) -> void:
	if start_offset_rotation == end_offset_rotation: return
	# Tween rotation
	tween.tween_property(
		_affected_node,
		"offset_transform_rotation",
		(deg_to_rad(end_offset_rotation) if end_offset_rotation != INF else current_offset_rotation) if forward else (deg_to_rad(start_offset_rotation) if start_offset_rotation != INF else current_offset_rotation),
		tween_duration
		).from(
			(deg_to_rad(start_offset_rotation) if start_offset_rotation != INF else current_offset_rotation) if forward else (deg_to_rad(end_offset_rotation) if end_offset_rotation != INF else current_offset_rotation)
			)


func _tween_offset_scale(tween : Tween, tween_duration : float, _affected_node : Node, forward : bool = true) -> void:
	if start_offset_scale == end_offset_scale: return
	# Tween scale.x
	tween.tween_property(
		_affected_node,
		"offset_transform_scale:x",
		(end_offset_scale.x if end_offset_scale.x != INF else current_offset_scale.x) if forward else (start_offset_scale.x if start_offset_scale.x != INF else current_offset_scale.x),
		tween_duration
		).from(
			(start_offset_scale.x if start_offset_scale.x != INF else current_offset_scale.x) if forward else (end_offset_scale.x if end_offset_scale.x != INF else current_offset_scale.x)
			)
	
	# Tween scale.y
	tween.tween_property(
		_affected_node,
		"offset_transform_scale:y",
		(end_offset_scale.y if end_offset_scale.y != INF else current_offset_scale.y) if forward else (start_offset_scale.y if start_offset_scale.y != INF else current_offset_scale.y),
		tween_duration
		).from(
			(start_offset_scale.y if start_offset_scale.y != INF else current_offset_scale.y) if forward else (end_offset_scale.y if end_offset_scale.y != INF else current_offset_scale.y)
			)


func _tween_offset_position_ratio(tween : Tween, tween_duration : float, _affected_node : Node, forward : bool = true) -> void:
	if start_offset_position_ratio == end_offset_position_ratio: return
	# Tween offset_transform_ratio.x
	tween.tween_property(
		_affected_node,
		"offset_transform_position_ratio:x",
		(end_offset_position_ratio.x if end_offset_position_ratio.x != INF else current_offset_position_ratio.x) if forward else (start_offset_position_ratio.x if start_offset_position_ratio.x != INF else current_offset_position_ratio.x),
		tween_duration
		).from(
			(start_offset_position_ratio.x if start_offset_position_ratio.x != INF else current_offset_position_ratio.x) if forward else (end_offset_position_ratio.x if end_offset_position_ratio.x != INF else current_offset_position_ratio.x)
			)
	
	# Tween offset_transform_ratio.y
	tween.tween_property(
		_affected_node,
		"offset_transform_position_ratio:y",
		(end_offset_position_ratio.y if end_offset_position_ratio.y != INF else current_offset_position_ratio.y) if forward else (start_offset_position_ratio.y if start_offset_position_ratio.y != INF else current_offset_position_ratio.y),
		tween_duration
		).from(
			(start_offset_position_ratio.y if start_offset_position_ratio.y != INF else current_offset_position_ratio.y) if forward else (end_offset_position_ratio.y if end_offset_position_ratio.y != INF else current_offset_position_ratio.y)
			)

#endregion


#region Custom Offset Transform Functions
func _custom_tween_offset_position(tween : Tween, tween_duration : float, _affected_node : Node, curve : Curve, forward : bool = true) -> void:
	if start_offset_position == end_offset_position: return
	# Set the starting from -> this exists because MethodTweener does not have the .from() function
	var starting_pos_x : float = (start_offset_position.x if start_offset_position.x != INF else current_offset_position.x) if forward else (end_offset_position.x if end_offset_position.x != INF else current_offset_position.x)
	var starting_pos_y : float = (start_offset_position.y if start_offset_position.y != INF else current_offset_position.y) if forward else (end_offset_position.y if end_offset_position.y != INF else current_offset_position.y)
	(_affected_node as Control).offset_transform_position = Vector2(starting_pos_x, starting_pos_y)
	
	# Tween along the curve and lerp towards the sampled point
	tween.tween_method(
		func (progress : float): # DON'T WORRY ABOUT IT JUST PASSES IN PROGRESS -> PROGRESS IS A NUMBER FROM THE MIN TO MAX VALUES
			var curve_progress : float = curve.sample_baked(progress)
			var target_pos_x : float = (end_offset_position.x if end_offset_position.x != INF else current_offset_position.x) if forward else (start_offset_position.x if start_offset_position.x != INF else current_offset_position.x)
			var target_pos_y : float = (end_offset_position.y if end_offset_position.y != INF else current_offset_position.y) if forward else (start_offset_position.y if start_offset_position.y != INF else current_offset_position.y)
			(_affected_node as Control).offset_transform_position = (Vector2(starting_pos_x, starting_pos_y)).lerp(Vector2(target_pos_x, target_pos_y), curve_progress)
			,
		curve.min_domain,
		curve.max_domain,
		tween_duration
	)


func _custom_tween_offset_rotation(tween : Tween, tween_duration : float, _affected_node : Node, curve : Curve, forward : bool = true) -> void:
	if start_offset_rotation == end_offset_rotation: return
	# Set the starting from -> this exists because MethodTweener does not have the .from() function
	var starting_rot : float = (deg_to_rad(start_offset_rotation) if start_offset_rotation != INF else current_offset_rotation) if forward else (deg_to_rad(end_offset_rotation) if end_offset_rotation != INF else current_offset_rotation)
	(_affected_node as Control).offset_transform_rotation = starting_rot
	
	# Tween along the curve and lerp towards the sampled point
	tween.tween_method(
		func (progress : float): # DON'T WORRY ABOUT IT JUST PASSES IN PROGRESS -> PROGRESS IS A NUMBER FROM THE MIN TO MAX VALUES
			var curve_progress : float = curve.sample_baked(progress)
			var target_rot : float = (end_offset_rotation if end_offset_rotation != INF else current_offset_rotation) if forward else (start_offset_rotation if start_offset_rotation != INF else current_offset_rotation)
			target_rot = deg_to_rad(target_rot)
			(_affected_node as Control).offset_transform_rotation = lerpf(starting_rot, target_rot, curve_progress)
			,
		curve.min_domain,
		curve.max_domain,
		tween_duration
	)


func _custom_tween_offset_scale(tween : Tween, tween_duration : float, _affected_node : Node, curve : Curve, forward : bool = true) -> void:
	if start_offset_scale == end_offset_scale: return
	# Set the starting from -> this exists because MethodTweener does not have the .from() function
	var starting_scale_x : float = (start_offset_scale.x if start_offset_scale.x != INF else current_offset_scale.x) if forward else (end_offset_scale.x if end_offset_scale.x != INF else current_offset_scale.x)
	var starting_scale_y : float = (start_offset_scale.y if start_offset_scale.y != INF else current_offset_scale.y) if forward else (end_offset_scale.y if end_offset_scale.y != INF else current_offset_scale.y)
	(_affected_node as Control).offset_transform_scale = Vector2(starting_scale_x, starting_scale_y)
	
	# Tween along the curve and lerp towards the sampled point
	tween.tween_method(
		func (progress : float): # DON'T WORRY ABOUT IT JUST PASSES IN PROGRESS -> PROGRESS IS A NUMBER FROM THE MIN TO MAX VALUES
			var curve_progress : float = curve.sample_baked(progress)
			var target_scale_x : float = (end_offset_scale.x if end_offset_scale.x != INF else current_offset_scale.x) if forward else (start_offset_scale.x if start_offset_scale.x != INF else current_offset_scale.x)
			var target_scale_y : float = (end_offset_scale.y if end_offset_scale.y != INF else current_offset_scale.y) if forward else (start_offset_scale.y if start_offset_scale.y != INF else current_offset_scale.y)
			(_affected_node as Control).offset_transform_scale = (Vector2(starting_scale_x, starting_scale_y)).lerp(Vector2(target_scale_x, target_scale_y), curve_progress)
			,
		curve.min_domain,
		curve.max_domain,
		tween_duration
	)


func _custom_tween_offset_position_ratio(tween : Tween, tween_duration : float, _affected_node : Node, curve : Curve, forward : bool = true) -> void:
	if start_offset_position_ratio == end_offset_position_ratio: return
	# Set the starting from -> this exists because MethodTweener does not have the .from() function
	var starting_pos_ratio_x : float = (start_offset_position_ratio.x if start_offset_position_ratio.x != INF else current_offset_position_ratio.x) if forward else (end_offset_position_ratio.x if end_offset_position_ratio.x != INF else current_offset_position_ratio.x)
	var starting_pos_ratio_y : float = (start_offset_position_ratio.y if start_offset_position_ratio.y != INF else current_offset_position_ratio.y) if forward else (end_offset_position_ratio.y if end_offset_position_ratio.y != INF else current_offset_position_ratio.y)
	(_affected_node as Control).offset_transform_position_ratio = Vector2(starting_pos_ratio_x, starting_pos_ratio_y)
	
	# Tween along the curve and lerp towards the sampled point
	tween.tween_method(
		func (progress : float): # DON'T WORRY ABOUT IT JUST PASSES IN PROGRESS -> PROGRESS IS A NUMBER FROM THE MIN TO MAX VALUES
			var curve_progress : float = curve.sample_baked(progress)
			var target_pos_ratio_x : float = (end_offset_position_ratio.x if end_offset_position_ratio.x != INF else current_offset_position_ratio.x) if forward else (start_offset_position_ratio.x if start_offset_position_ratio.x != INF else current_offset_position_ratio.x)
			var target_pos_ratio_y : float = (end_offset_position_ratio.y if end_offset_position_ratio.y != INF else current_offset_position_ratio.y) if forward else (start_offset_position_ratio.y if start_offset_position_ratio.y != INF else current_offset_position_ratio.y)
			(_affected_node as Control).offset_transform_scale = (Vector2(starting_pos_ratio_x, starting_pos_ratio_y)).lerp(Vector2(target_pos_ratio_x, target_pos_ratio_y), curve_progress)
			,
		curve.min_domain,
		curve.max_domain,
		tween_duration
	)
#endregion


## Set the current offset transform values when the tween is run
func set_current_values(_affected_node : Control) -> void:
	current_offset_position = _affected_node.offset_transform_position
	current_offset_rotation = _affected_node.offset_transform_rotation
	current_offset_scale = _affected_node.offset_transform_scale
	current_offset_position_ratio = _affected_node.offset_transform_position_ratio


## NOTE: ONLY TO BE USED IN THE EDITOR
func _set_reset_values(_affected_node : Control) -> void:
	reset_offset_position = _affected_node.offset_transform_position
	reset_offset_rotation = _affected_node.offset_transform_rotation
	reset_offset_scale = _affected_node.offset_transform_scale
	reset_offset_position_ratio = _affected_node.offset_transform_position_ratio
