@abstract class_name TweenResource extends Resource

## NOTE: How to format a property tween function
#func _tween_position(tween : Tween, tween_duration : float, _affected_node : Node, forward : bool = true) -> void:
	## NOTE: If there are Vector2/3/4 then tween each value differently as to not run excess code
	#if start_position.x != end_position.x: -> NOTE: Checks to see if there are two different values to tween between, if not it just skips
		#tween.tween_property(
			#_affected_node,
			#"position:x",
			## NOTE: Tweens a property towards either the ending value if the tween is being played forward, or towards the starting value if backward.
			## NOTE: Turnary operators in parenthesis check if it should tween to a value set in editor or the current state of the value the node has.
			#(end_position.x if end_position.x != INF else current_position.x) if forward else (start_position.x if start_position.x != INF else current_position.x),
			#tween_duration
			## NOTE : This is just dictating the starting point of the tween with the same logic as above, just in reverse
			#).from(
				#(start_position.x if start_position.x != INF else current_position.x) if forward else (end_position.x if end_position.x != INF else current_position.x)
				#)
	#if start_position.y != end_position.y:
		#tween.tween_property(
			#_affected_node,
			#"position:y",
			#(end_position.y if end_position.y != INF else current_position.y) if forward else (start_position.y if start_position.y != INF else current_position.y),
			#tween_duration
			#).from(
				#(start_position.y if start_position.y != INF else current_position.y) if forward else (end_position.y if end_position.y != INF else current_position.y)
				#)

## NOTE: How to formate a property tween function with a custom curve
#func _custom_tween_position(tween : Tween, tween_duration : float, _affected_node : Node, curve : Curve, forward : bool = true) -> void:
	## Set the starting from -> this exists because MethodTweener does not have the .from() function
	#var starting_pos_x : float = (start_position.x if start_position.x != INF else current_position.x) if forward else (end_position.x if end_position.x != INF else current_position.x)
	#var starting_pos_y : float = (start_position.y if start_position.y != INF else current_position.y) if forward else (end_position.y if end_position.y != INF else current_position.y)
	#(_affected_node as Control).offset_transform_position = Vector2(starting_pos_x, starting_pos_y)
	#
	
	#tween.tween_method(
		#func (progress : float): # DON'T WORRY ABOUT IT JUST PASSES IN PROGRESS -> PROGRESS IS A NUMBER FROM THE MIN TO MAX VALUES
			#var curve_progress : float = curve.sample_baked(progress)
			#var target_pos_x : float = (end_position.x if end_position.x != INF else current_position.x) if forward else (start_position.x if start_position.x != INF else current_position.x)
			#var target_pos_y : float = (end_position.y if end_position.y != INF else current_position.y) if forward else (start_position.y if start_position.y != INF else current_position.y)
			#(_affected_node as Control).offset_transform_position = (Vector2(starting_pos_x, starting_pos_y)).lerp(Vector2(target_pos_x, target_pos_y), curve_progress)
			#,
		#curve.min_domain,
		#curve.max_domain,
		#tween_duration
	#)




@abstract func tween_properties(tween : Tween, tween_duration : float, _affected_node : Node, forward : bool = true) -> void

@abstract func custom_tween_properties(tween : Tween, tween_duration : float, _affected_node : Node, curve : Curve, forward : bool = true) -> void

@abstract func set_current_values(_affected_node) -> void

@abstract func _set_reset_values(_affected_node) -> void

@abstract func _reset_values(_affected_node) -> void
