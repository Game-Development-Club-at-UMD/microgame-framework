extends RigidBody2D

var letter = ""
var points = 0
var marker_id = -1

@onready var art = $Art
@onready var glow = $Art/Glow
@onready var sprite = $Art/Sprite
@onready var glyph = $Glyph
@onready var glow_pulse = $GlowPulse


func setup(texture, new_letter, new_points, cell_size):
	letter = new_letter
	points = new_points
	sprite.texture = texture

	var fit = cell_size / texture.get_width()
	sprite.scale = Vector2(fit, fit)
	glow.scale = Vector2(fit * 0.65, fit * 0.65)

	glow.visible = false
	glyph.text = ""


func make_live(id, color, symbol):
	marker_id = id
	glow.self_modulate = color
	glow.visible = true
	glyph.text = symbol
	glyph.modulate = color
	glow_pulse.do_tween_sequence()


func stop_glowing():
	glow_pulse.stop_sequence()
	glow.visible = false
	glyph.text = ""
