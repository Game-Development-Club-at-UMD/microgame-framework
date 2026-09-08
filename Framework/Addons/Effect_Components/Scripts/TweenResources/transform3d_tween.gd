@tool
class_name Transform3DTween extends TweenResource


#region Transform Properties
@export_group("Position")
## The position the tween will start at. [br]
## Has INF values by default, and will ignore individual x or y if left unchanged.
@export var start_position : Vector3 = Vector3.INF

## The position the tween will end at. [br]
## Has INF values by default, and will ignore individual x or y if left unchanged.
@export var end_position : Vector3 = Vector3.INF

## The current position of the node, stored in a variable
var current_position : Vector3

@export_group("Rotation")

## The rotation amount is the rotation degrees the tween will start at. [br]
## Has INF value by default, and will ignore this parameter if unchanged.
@export var start_rotation : Vector3 = Vector3.INF

## The rotation amount is the rotation degrees the tween will end at. [br]
## Has INF value by default, and will ignore this parameter if unchanged.
@export var end_rotation : Vector3 = Vector3.INF

## The current rotate of the node in rotation_degrees, stored in a variable
var current_rotation : Vector3

@export_group("Scale")

## The scale amount is the scale the tween will start at. [br]
## Has INF values by default, and will ignore individual x or y if left unchanged.
@export var start_scale : Vector3 = Vector3.INF

## The scale amount is the scale the tween will end at. [br]
## Has INF values by default, and will ignore individual x or y if left unchanged.
@export var end_scale : Vector3 = Vector3.INF

## The current rotate of the node in rotation_degrees, stored in a variable
var current_scale : Vector3

## The value the position is reset to in the editor
var reset_position : Vector3
## The value the rotation is reset to in the editor
var reset_rotation : Vector3
## The value the scale is reset to in the editor
var reset_scale : Vector3
#endregion


## Execute transform tweens for the [param affected_node].
func tween_properties(tween : Tween, tween_duration : float, _affected_node : Node, forward : bool = true) -> void:
	_tween_position(tween, tween_duration, _affected_node as Node3D, forward)
	_tween_rotation(tween, tween_duration, _affected_node as Node3D, forward)
	_tween_scale(tween, tween_duration, _affected_node as Node3D, forward)


## Execute transform tweens for the [param affected_node] with a custom transition curve.
func custom_tween_properties(tween : Tween, tween_duration : float, _affected_node : Node, curve : Curve, forward : bool = true) -> void:
	_custom_tween_position(tween, tween_duration, _affected_node as Node3D, curve, forward)
	_custom_tween_rotation(tween, tween_duration, _affected_node as Node3D, curve, forward)
	_custom_tween_scale(tween, tween_duration, _affected_node as Node3D, curve, forward)


## NOTE: ONLY TO BE USED IN THE EDITOR
func _reset_values(_affected_node : Node3D) -> void:
	if reset_position == null or reset_rotation == null or reset_scale == null :
		printerr("%s: Some reset value in %s, was not set." % [_affected_node.name, self.get_class()])
		return
	
	_affected_node.position = reset_position
	_affected_node.rotation = reset_rotation
	_affected_node.scale = reset_scale


#region Transform Functions
func _tween_position(tween : Tween, tween_duration : float, _affected_node : Node3D, forward : bool = true) -> void:
	if start_position == end_position: return
	# Tween the positions if not default
	if start_position.x != end_position.x:
		tween.tween_property(
			_affected_node,
			"position:x",
			(end_position.x if end_position.x != INF else current_position.x) if forward else (start_position.x if start_position.x != INF else current_position.x),
			tween_duration
			).from(
				(start_position.x if start_position.x != INF else current_position.x) if forward else (end_position.x if end_position.x != INF else current_position.x)
				)
	if start_position.y != end_position.y:
		tween.tween_property(
			_affected_node,
			"position:y",
			(end_position.y if end_position.y != INF else current_position.y) if forward else (start_position.y if start_position.y != INF else current_position.y),
			tween_duration
			).from(
				(start_position.y if start_position.y != INF else current_position.y) if forward else (end_position.y if end_position.y != INF else current_position.y)
				)
	if start_position.z != end_position.z:
		tween.tween_property(
			_affected_node,
			"position:z",
			(end_position.z if end_position.z != INF else current_position.z) if forward else (start_position.z if start_position.z != INF else current_position.z),
			tween_duration
			).from(
				(start_position.z if start_position.z != INF else current_position.z) if forward else (end_position.z if end_position.z != INF else current_position.z)
				)


func _tween_rotation(tween : Tween, tween_duration : float, _affected_node : Node3D, forward : bool = true) -> void:
	if start_rotation == end_rotation: return
	# Tween the rotation if not default
	if start_position.x != end_position.x:
		tween.tween_property(
			_affected_node,
			"rotation_degrees:x",
			(end_rotation.x if end_rotation.x != INF else current_rotation.x) if forward else (start_rotation.x if start_rotation.x != INF else current_rotation.x),
			tween_duration
			).from(
				(start_rotation.x if start_rotation.x != INF else current_rotation.x) if forward else (end_rotation.x if end_rotation.x != INF else current_rotation.x)
				)
	if start_position.y != end_position.y:
		tween.tween_property(
			_affected_node,
			"rotation_degrees:y",
			(end_rotation.y if end_rotation.y != INF else current_rotation.y) if forward else (start_rotation.y if start_rotation.y != INF else current_rotation.y),
			tween_duration
			).from(
				(start_rotation.y if start_rotation.y != INF else current_rotation.y) if forward else (end_rotation.y if end_rotation.y != INF else current_rotation.y)
				)
	if start_position.z != end_position.z:
		tween.tween_property(
			_affected_node,
			"rotation_degrees:z",
			(end_rotation.z if end_rotation.z != INF else current_rotation.z) if forward else (start_rotation.z if start_rotation.z != INF else current_rotation.z),
			tween_duration
			).from(
				(start_rotation.z if start_rotation.z != INF else current_rotation.z) if forward else (end_rotation.z if end_rotation.z != INF else current_rotation.z)
				)


func _tween_scale(tween : Tween, tween_duration : float, _affected_node : Node3D, forward : bool = true) -> void:
	if start_scale == end_scale: return
	# Tween the scale if not default
	if start_scale.x != end_scale.x:
		tween.tween_property(
			_affected_node,
			"scale:x",
			(end_scale.x if end_scale.x != INF else current_scale.x) if forward else (start_scale.x if start_scale.x != INF else current_scale.x),
			tween_duration
			).from(
				(start_scale.x if start_scale.x != INF else current_scale.x) if forward else (end_scale.x if end_scale.x != INF else current_scale.x)
				)
	if start_scale.y != end_scale.y:
		tween.tween_property(
			_affected_node,
			"scale:y",
			(end_scale.y if end_scale.y != INF else current_scale.y) if forward else (start_scale.y if start_scale.y != INF else current_scale.y),
			tween_duration
			).from(
				(start_scale.y if start_scale.y != INF else current_scale.y) if forward else (end_scale.y if end_scale.y != INF else current_scale.y)
				)
	if start_scale.z != end_scale.z:
		tween.tween_property(
			_affected_node,
			"scale:z",
			(end_scale.z if end_scale.z != INF else current_scale.z) if forward else (start_scale.z if start_scale.z != INF else current_scale.z),
			tween_duration
			).from(
				(start_scale.z if start_scale.z != INF else current_scale.z) if forward else (end_scale.z if end_scale.z != INF else current_scale.z)
				)
#endregion


#region Custom Transform Functions
func _custom_tween_position(tween : Tween, tween_duration : float, _affected_node : Node3D, curve : Curve, forward : bool = true) -> void:
	if start_position == end_position: return
	# Set the starting from -> this exists because MethodTweener does not have the .from() function
	var starting_pos_x : float = (start_position.x if start_position.x != INF else current_position.x) if forward else (end_position.x if end_position.x != INF else current_position.x)
	var starting_pos_y : float = (start_position.y if start_position.y != INF else current_position.y) if forward else (end_position.y if end_position.y != INF else current_position.y)
	var starting_pos_z : float = (start_position.z if start_position.z != INF else current_position.z) if forward else (end_position.z if end_position.z != INF else current_position.z)
	_affected_node.position = Vector3(starting_pos_x, starting_pos_y, starting_pos_z)
	
	# Tween along the curve and lerp towards the sampled point
	tween.tween_method(
		func (progress : float): # DON'T WORRY ABOUT IT JUST PASSES IN PROGRESS -> PROGRESS IS A NUMBER FROM THE MIN TO MAX VALUES
			var curve_progress : float = curve.sample_baked(progress)
			var target_pos_x : float = (end_position.x if end_position.x != INF else current_position.x) if forward else (start_position.x if start_position.x != INF else current_position.x)
			var target_pos_y : float = (end_position.y if end_position.y != INF else current_position.y) if forward else (start_position.y if start_position.y != INF else current_position.y)
			var target_pos_z : float = (end_position.z if end_position.z != INF else current_position.z) if forward else (start_position.z if start_position.z != INF else current_position.z)
			_affected_node.position = (Vector3(starting_pos_x, starting_pos_y, starting_pos_z)).lerp(Vector3(target_pos_x, target_pos_y, target_pos_z), curve_progress)
			,
		curve.min_domain,
		curve.max_domain,
		tween_duration
	)


func _custom_tween_rotation(tween : Tween, tween_duration : float, _affected_node : Node3D, curve : Curve, forward : bool = true) -> void:
	if start_rotation == end_rotation: return
	# Set the starting from -> this exists because MethodTweener does not have the .from() function
	var starting_rot_x : float = (start_rotation.x if start_rotation.x != INF else current_rotation.x) if forward else (end_rotation.x if end_rotation.x != INF else current_rotation.x)
	var starting_rot_y : float = (start_rotation.y if start_rotation.y != INF else current_rotation.y) if forward else (end_rotation.y if end_rotation.y != INF else current_rotation.y)
	var starting_rot_z : float = (start_rotation.z if start_rotation.z != INF else current_rotation.z) if forward else (end_rotation.z if end_rotation.z != INF else current_rotation.z)
	_affected_node.rotation_degrees = Vector3(starting_rot_x, starting_rot_y, starting_rot_z)
	
	# Tween along the curve and lerp towards the sampled point
	tween.tween_method(
		func (progress : float): # DON'T WORRY ABOUT IT JUST PASSES IN PROGRESS -> PROGRESS IS A NUMBER FROM THE MIN TO MAX VALUES
			var curve_progress : float = curve.sample_baked(progress)
			var target_rot_x : float = (end_rotation.x if end_rotation.x != INF else current_rotation.x) if forward else (start_rotation.x if start_rotation.x != INF else current_rotation.x)
			var target_rot_y : float = (end_rotation.y if end_rotation.y != INF else current_rotation.y) if forward else (start_rotation.y if start_rotation.y != INF else current_rotation.y)
			var target_rot_z : float = (end_rotation.z if end_rotation.z != INF else current_rotation.z) if forward else (start_rotation.z if start_rotation.z != INF else current_rotation.z)
			#_affected_node.rotation_degrees = lerpf(starting_rot, target_rot, curve_progress)
			_affected_node.rotation_degrees = (Vector3(starting_rot_x, starting_rot_y, starting_rot_z)).lerp(Vector3(target_rot_x, target_rot_y, target_rot_z), curve_progress)
			,
		curve.min_domain,
		curve.max_domain,
		tween_duration
	)


func _custom_tween_scale(tween : Tween, tween_duration : float, _affected_node : Node3D, curve : Curve, forward : bool = true) -> void:
	if start_scale == end_scale: return
	# Set the starting from -> this exists because MethodTweener does not have the .from() function
	var starting_scale_x : float = (start_scale.x if start_scale.x != INF else current_scale.x) if forward else (end_scale.x if end_scale.x != INF else current_scale.x)
	var starting_scale_y : float = (start_scale.y if start_scale.y != INF else current_scale.y) if forward else (end_scale.y if end_scale.y != INF else current_scale.y)
	var starting_scale_z : float = (start_scale.z if start_scale.z != INF else current_scale.z) if forward else (end_scale.z if end_scale.z != INF else current_scale.z)
	_affected_node.scale = Vector3(starting_scale_x, starting_scale_y, starting_scale_z)
	
	# Tween along the curve and lerp towards the sampled point
	tween.tween_method(
		func (progress : float): # DON'T WORRY ABOUT IT JUST PASSES IN PROGRESS -> PROGRESS IS A NUMBER FROM THE MIN TO MAX VALUES
			var curve_progress : float = curve.sample_baked(progress)
			var target_scale_x : float = (end_scale.x if end_scale.x != INF else current_scale.x) if forward else (start_scale.x if start_scale.x != INF else current_scale.x)
			var target_scale_y : float = (end_scale.y if end_scale.y != INF else current_scale.y) if forward else (start_scale.y if start_scale.y != INF else current_scale.y)
			var target_scale_z : float = (end_scale.z if end_scale.z != INF else current_scale.z) if forward else (start_scale.z if start_scale.z != INF else current_scale.z)
			_affected_node.scale = (Vector3(starting_scale_x, starting_scale_y, starting_scale_z)).lerp(Vector3(target_scale_x, target_scale_y, target_scale_z), curve_progress)
			,
		curve.min_domain,
		curve.max_domain,
		tween_duration
	)
#endregion


func set_current_values(_affected_node : Node3D) -> void:
	current_position = _affected_node.position
	current_rotation = _affected_node.rotation
	current_scale = _affected_node.scale


## NOTE: ONLY TO BE USED IN THE EDITOR
func _set_reset_values(_affected_node : Node3D) -> void:
	reset_position = _affected_node.position
	reset_rotation = _affected_node.rotation
	reset_scale = _affected_node.scale
