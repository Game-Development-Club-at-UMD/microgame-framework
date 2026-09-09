@icon("res://ExampleGame/Bubble/Assets/EvilBubble.png")
class_name EvilBubble extends Bubble


func pop_bubble() -> void:
	bubble_popped.emit()
	super()
