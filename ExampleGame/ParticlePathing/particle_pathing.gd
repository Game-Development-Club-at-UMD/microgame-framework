class_name ParticlePathing extends Path2D

const BUBBLE = preload("uid://bjygjlqt7kmgu")
const PathFollow2d = preload("uid://d3xire3t1b2b5")

signal decrease_bubble_count
signal evil_bubble_clicked
@export var speed : float = 0.1
var bubbles : Array[Bubble]
func _ready() -> void:
	for bubble in get_children():
		if bubble is not Bubble:
			continue
		bubbles.append(bubble as Bubble)
		if bubble is GoodBubble:
			(get_parent() as BubbleGame).increase_bubble_count()
			(bubble as Bubble).bubble_popped.connect(call_bubble_count_decrease)
		elif bubble is EvilBubble:
			(bubble as Bubble).bubble_popped.connect(_on_evil_bubble_popped)
		parent_bubble_to_line_follow(bubble as Bubble)
	space_out_bubbles()


func parent_bubble_to_line_follow(bubble : Bubble) -> void:
	var path : ParticleFollow = ParticleFollow.new()
	path.set_script(PathFollow2d)
	path.speed = speed
	add_child(path)
	bubble.reparent(path, false)
	bubble.position = Vector2.ZERO


func space_out_bubbles() -> void:
	var progress_amount : float = 0
	for child in get_children():
		if child is not ParticleFollow:
			return
		progress_amount += (1/float(get_child_count()))
		(child as ParticleFollow).progress_ratio = progress_amount

func _on_evil_bubble_popped():
	for bubble in bubbles:
		if is_instance_valid(bubble):
			bubble.area_2d.input_pickable = false
	evil_bubble_clicked.emit()

func call_bubble_count_decrease() -> void:
	decrease_bubble_count.emit()
