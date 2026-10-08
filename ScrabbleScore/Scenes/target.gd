extends Area2D

signal clicked(target)

var marker_id = -1
var cell = Vector2i.ZERO

@onready var glow = $Glow
@onready var glyph = $Glyph
@onready var glow_pulse = $GlowPulse


func setup(texture, id, color, symbol, cell_size):
	marker_id = id
	glow.self_modulate = color

	var fit = cell_size / texture.get_width()
	glow.scale = Vector2(fit * 0.5, fit * 0.5) * 1.15

	glyph.text = symbol
	glyph.modulate = color

	glow_pulse.do_tween_sequence()


func _on_input_event(_viewport, event, _shape_index):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			clicked.emit(self)
