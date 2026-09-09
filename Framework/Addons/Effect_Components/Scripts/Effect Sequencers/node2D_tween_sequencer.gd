@tool
class_name Node2DTweenSequencer extends Node
## The purpose of [Node2DTweenSequencer] is to hold and call a series of [Node2DEffect]
## in sequence, to allow for the more complex tween animation.

## Plays the tween in the editor, and resets once complete
@export_tool_button("Play Tween", "Play") var play_tween_button : Callable = do_tween_sequence
## Resets the tween immediately
@export_tool_button("Reset Tween", "Stop") var reset_tween_button : Callable = _reset_values
## Sets the value that the reset button goes to
@export_tool_button("Set Reset Values", "KeyValue") var set_reset_value_button : Callable = _set_reset_values

## The node which was have a sequence of effects applied
@export var affected_node : Node2D

## Determines if the array of effects will loop once completed
@export var loop : bool = false

## Starts the array of effects upon all nodes becoming ready
@export var autostart : bool = false

## Array of held [Node2DEffect]
@export var tween_array : Array[Node2DTween]


func _ready() -> void:
	# Check if there is a node
	if !affected_node:
		return
	# Start sequence if autostart is enabled
	if autostart:
		do_tween_sequence()
	


## Calls the do_effect of every [Node2DEffect] in sequence
func do_tween_sequence() -> void:
	# Check if there is a node to affect
	if !affected_node:
		printerr(self, "There was no node to apply effects to!")
		return
	
	for node2D_tween : Node2DTween in tween_array:
		node2D_tween.affected_node = affected_node
		
		# Disable loop for all effects
		if node2D_tween.loop:
			node2D_tween.loop = false
			printerr(node2D_tween, "Set loop to false, does not apply when played in sequence.")
		
		# Disable autostart for all effects
		if node2D_tween.autostart:
			node2D_tween.autostart = false
			printerr(node2D_tween, "Set autostart to false, does not apply when played in sequence.")
		
		node2D_tween.do_tween()
		await node2D_tween.tween_finished
		
	
	# We loopin
	if loop:
		do_tween_sequence()


## Stops the sequence by killing every tween in the array of [member effect_array]
func stop_sequence() -> void:
	for node2D_tween : Node2DTween in tween_array:
		node2D_tween._stop_tween()


func _reset_values() -> void:
	if !affected_node: return
	if tween_array.is_empty(): return
	
	tween_array[0]._reset_values()


func _set_reset_values() -> void:
	if !affected_node: return
	if tween_array.is_empty(): return
	
	tween_array[0]._set_reset_values()
