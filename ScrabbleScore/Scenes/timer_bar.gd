extends Node2D


@export var thickness: float = 10.0
@export var margin: float = 5.0
@export var full_color: Color = Color("a3ff3c")
@export var warn_color: Color = Color("ff3b5c")
@export var warn_at: float = 0.25
@export var samples: int = 240

@onready var left_line = $Left
@onready var right_line = $Right

var left_points = []
var right_points = []


func _ready() -> void:
	var screen = get_viewport_rect().size
	var top = margin
	var bottom = screen.y - margin
	var left = margin
	var right = screen.x - margin
	var middle = screen.x / 2.0
	
	right_points = sample_path([
		Vector2(middle, top),
		Vector2(right, top),
		Vector2(right, bottom),
		Vector2(middle, bottom),
	])
	
	left_points = sample_path([
		Vector2(middle, top),
		Vector2(left, top),
		Vector2(left, bottom),
		Vector2(middle, bottom),
	])
	
	for line in [left_line, right_line]:
		line.width = thickness
		line.default_color = full_color
		line.joint_mode = Line2D.LINE_JOINT_ROUND
		line.begin_cap_mode = Line2D.LINE_CAP_ROUND
		line.end_cap_mode = Line2D.LINE_CAP_ROUND
	
	set_progress(1.0)


func sample_path(corners):
	var total = 0.0
	for i in range(corners.size() - 1):
		total += corners[i].distance_to(corners[i + 1])
	
	var result = []
	for i in range(samples + 1):
		var wanted = total * float(i) / float(samples)
		var walked = 0.0
		for j in range(corners.size() - 1):
			var length = corners[j].distance_to(corners[j + 1])
			if walked + length >= wanted:
				var t = (wanted - walked) / length
				result.append(corners[j].lerp(corners[j + 1], t))
				break
			walked += length
	return result


func set_progress(amount):
	amount = clamp(amount, 0.0, 1.0)
	var drop = int((1.0 - amount) * samples)
	
	left_line.points = PackedVector2Array(left_points.slice(drop))
	right_line.points = PackedVector2Array(right_points.slice(drop))
	var color = full_color if amount > warn_at else warn_color
	left_line.default_color = color
	right_line.default_color = color


func flash():
	var t = create_tween()
	t.tween_property(left_line, "width", thickness * 2.2, 0.04)
	t.parallel().tween_property(right_line, "width", thickness * 2.2, 0.04)
	t.tween_property(left_line, "width", thickness, 0.18)
	t.parallel().tween_property(right_line, "width", thickness, 0.18)
