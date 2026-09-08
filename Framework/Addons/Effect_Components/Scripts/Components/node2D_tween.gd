@icon("uid://mc5sx2ggbl4q")
@tool
class_name Node2DTween extends TweenComponent
## [Node2DEffect] is an extension of [TweenEffect] and additionally contains
## transform and [CanvasItem] parameters.

## Plays the tween in the editor, and resets once complete
@export_tool_button("Play Tween", "Play") var play_tween_button : Callable = _do_editor_tween
## Resets the tween immediately
@export_tool_button("Reset Tween", "Stop") var reset_tween_button : Callable = _reset_values
## Sets the value that the reset button goes to
@export_tool_button("Set Reset Values", "KeyValue") var set_reset_value_button : Callable = _set_reset_values
## The node which will have the effect applied.
@export var affected_node : Node2D
## The transform tween resource
@export var transform_tween : TransformTween:
	set(new_tween):
		transform_tween = new_tween
		if new_tween != null and affected_node != null:
			_set_reset_values()
## The canvas item tween resource
@export var canvas_item_tween : CanvasItemTween:
	set(new_tween):
		canvas_item_tween = new_tween
		if new_tween != null and affected_node != null:
			_set_reset_values()


func _ready() -> void:
	# Don't run this if you're in the editor
	if Engine.is_editor_hint():
		_set_reset_values()
		return
	
	super()
	if has_errors(): return
	
	if autostart: do_tween()


func do_tween(forward : bool = true) -> void:
	if has_errors(): return
	
	# Create a new tween with given parameters
	_reset_tween()
	# Set all the current values for the relevant tween values
	set_current_values()
	# Set up the loop
	if loop:
		tween.set_loops()
	
	# Tween that shit
	_tween_values(forward)
	_kill_empty_tween()
	
	# Set up chaining
	if loop:
		tween.chain()
		_tween_values(forward)
	
	# Await for tween to finish so that it can loop
	await tween.finished
	return


func _do_editor_tween() -> void:
	do_tween()


## Wrapper to call the tween functions from all the tween resources
func _tween_values(forward : bool = true) -> void:
	if !use_custom_curve:
		if transform_tween != null: transform_tween.tween_properties(tween, tween_duration, affected_node, forward)
		if canvas_item_tween != null: canvas_item_tween.tween_properties(tween, tween_duration, affected_node, forward)
	else:
		if transform_tween != null: transform_tween.custom_tween_properties(tween, tween_duration, affected_node, transition_curve, forward)
		if canvas_item_tween != null: canvas_item_tween.custom_tween_properties(tween, tween_duration, affected_node, transition_curve, forward)


## Sets the current transform values to the [member affected_node]
func set_current_values() -> void:
	if transform_tween != null: transform_tween.set_current_values(affected_node)
	if canvas_item_tween != null: canvas_item_tween.set_current_values(affected_node)


## Sets the reset values that the [member affected_node] is set to in the editor
## NOTE: ONLY TO BE USED IN THE EDITOR
func _set_reset_values() -> void:
	if transform_tween != null: transform_tween._set_reset_values(affected_node)
	if canvas_item_tween != null: canvas_item_tween._set_reset_values(affected_node)


## Resets the values to reset value
## NOTE: ONLY TO BE USED IN THE EDITOR
func _reset_values() -> void:
	if loop and tween.is_running():
		tween.stop()
	if transform_tween != null: transform_tween._reset_values(affected_node)
	if canvas_item_tween != null: canvas_item_tween._reset_values(affected_node)


## Returns a boolean if any errors were found, and gives an error pointing to the issue.
func has_errors() -> bool:
	# If there is no node, that shit will NOT work
	if !affected_node:
		printerr("%s: No node assigned to %s, and attempted to run." % [self, self.name])
		return true
	
	return false
