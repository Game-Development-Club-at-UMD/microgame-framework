@icon("res://ExampleGame/Bubble/Assets/Bubble.png")
class_name GoodBubble extends Bubble

func pop_bubble() -> void:
	super()
	bubble_popped.emit()
