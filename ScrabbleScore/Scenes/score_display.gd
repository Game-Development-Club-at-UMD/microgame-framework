extends Node2D

# Walks a ScoreRules plan.

@export var chip_sound: AudioStream
@export var letter_mult_sound: AudioStream
@export var word_mult_sound: AudioStream
@export var reveal_sound: AudioStream
@export var smoosh_sound: AudioStream
@export var bank_sound: AudioStream

@export var reveal_gap: float = 0.06
@export var chip_gap: float = 0.16
@export var mult_gap: float = 0.34
@export var word_end_hold: float = 0.4
@export var pitch_step: float = 0.055
@export var reveal_pitch_step: float = 0.07

@export var label_size: Vector2 = Vector2(360, 110)
@export var tally_offset: Vector2 = Vector2(0, 120.0)
@export var plus_gap: float = 110.0
@export var branch_gap: float = 210.0

@export var chip_pop: float = 1.25
@export var branch_pop: float = 1.45
@export var word_mult_pop: float = 1.7
@export var merge_pop: float = 1.9
@export var reveal_scale: float = 1.7
@export var score_pop_scale: float = 1.5
@export var score_mult_scale: float = 2.1

@export var merge_hold: float = 0.1

@onready var total_label: Label = $TotalLabel
@onready var plus_label: Label = $PlusLabel
@onready var branch_label: Label = $BranchLabel

# Single components. Safe to fire without await.
@onready var pop_tween = $Juice/Pop
@onready var score_pop_tween = $Juice/ScorePop
@onready var slide_a = $Juice/SlideA
@onready var slide_b = $Juice/SlideB

# Sequencers. Always awaited.
@onready var reveal_seq = $Juice/TileReveal
@onready var flash_seq = $Juice/Flash
@onready var shake_seq = $Juice/Shake

# One fade per label, affected_node set in the inspector and never reassigned.
@onready var total_fade_in = $Juice/TotalFadeIn
@onready var plus_fade_in = $Juice/PlusFadeIn
@onready var plus_fade_out = $Juice/PlusFadeOut
@onready var branch_fade_in = $Juice/BranchFadeIn

var board_origin = Vector2.ZERO
var cell_size = 36.0
var tiles_by_cell = {}
var tally_center = Vector2.ZERO
var players = []
var next_player = 0

# The art node currently mid-pop, so it can be put back to rest when stolen.
var popping_art = null
var popping_label = null


func _ready() -> void:
	for i in range(8):
		var p = AudioStreamPlayer.new()
		add_child(p)
		players.append(p)


func setup(origin, cell, tiles):
	board_origin = origin
	cell_size = cell
	tiles_by_cell = tiles

	# Every position below is in this node's local space, so it has to sit at
	# the origin or the whole display drifts.
	position = Vector2.ZERO
	scale = Vector2.ONE
	rotation = 0.0

	var screen = get_viewport_rect().size
	tally_center = Vector2(screen.x / 2.0, board_origin.y) + tally_offset

	for l in [total_label, plus_label, branch_label]:
		# Anchors recompute position and size every frame and would fight
		# everything this script does, so pin them to top left.
		l.set_anchors_preset(Control.PRESET_TOP_LEFT, true)
		l.anchor_left = 0.0
		l.anchor_top = 0.0
		l.anchor_right = 0.0
		l.anchor_bottom = 0.0
		l.grow_horizontal = Control.GROW_DIRECTION_END
		l.grow_vertical = Control.GROW_DIRECTION_END

		l.autowrap_mode = TextServer.AUTOWRAP_OFF
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		l.mouse_filter = Control.MOUSE_FILTER_IGNORE

		l.custom_minimum_size = Vector2.ZERO
		l.size = label_size
		l.pivot_offset = label_size / 2.0
		l.modulate = Color(1, 1, 1, 0)
		l.scale = Vector2.ONE

	plus_label.text = "+"


#region helpers
func centre_on(label, point):
	label.position = point - label.size / 2.0


func branch_home():
	return tally_center + Vector2(branch_gap, 0)


func cell_centre(cell):
	return board_origin + Vector2(cell) * cell_size + Vector2(cell_size, cell_size) / 2.0


func play(stream, pitch = 1.0, volume_db = 0.0):
	if stream == null:
		return
	var p = players[next_player]
	next_player = (next_player + 1) % players.size()
	p.stream = stream
	p.pitch_scale = pitch
	p.volume_db = volume_db
	p.play()


# Single component, so it writes start_scale and eases back to 1. Restarting it
# kills the previous target's settle, so that node is reset before the steal.
func pop(label, amount):
	if popping_label != null and popping_label != label:
		popping_label.scale = Vector2.ONE
	popping_label = label

	pop_tween.transform_tween.start_scale = Vector2.ONE * amount
	pop_tween.affected_node = label
	pop_tween.do_tween()


# Beat two of a letter: the tile reacts as its score is counted.
func score_pop_tile(cell, big):
	var tile = tiles_by_cell.get(cell)
	if tile == null:
		return
	rest_popping_art(tile.art)

	tile.z_index = 200
	score_pop_tween.transform_tween.start_scale = \
		Vector2.ONE * (score_mult_scale if big else score_pop_scale)
	score_pop_tween.affected_node = tile.art
	score_pop_tween.do_tween()


func rest_popping_art(incoming):
	if popping_art != null and popping_art != incoming:
		popping_art.scale = Vector2.ONE
	popping_art = incoming


func drop_tiles(cells):
	if popping_art != null:
		popping_art.scale = Vector2.ONE
		popping_art = null
	for c in cells:
		var tile = tiles_by_cell.get(c)
		if tile != null:
			tile.z_index = 0


func flash(label):
	flash_seq.affected_node = label
	await flash_seq.do_tween_sequence()


func slide(component, label, destination):
	component.affected_node = label
	component.transform_tween.end_position = destination - label.size / 2.0
	await component.do_tween()


# prefix must contain a single %d.
func count_to(label, prefix, from, to, duration):
	if from == to or duration <= 0.0:
		label.text = prefix % to
		return
	var elapsed = 0.0
	while elapsed < duration:
		await get_tree().process_frame
		elapsed += get_process_delta_time()
		var amount = min(elapsed / duration, 1.0)
		label.text = prefix % int(lerp(float(from), float(to), amount))
	label.text = prefix % to


func wait(seconds):
	await get_tree().create_timer(seconds).timeout
#endregion


# The whole sequence. Await this. Returns the round total.
func play_plan(plan):
	var carried = 0

	# The total is placed once and never moves again.
	total_label.text = "0"
	centre_on(total_label, tally_center)
	centre_on(plus_label, tally_center + Vector2(plus_gap, 0))
	total_fade_in.do_tween()
	await wait(0.25)

	for entry in plan:
		var word_total = await score_one_word(entry)
		carried += word_total
		await merge(carried, word_total)

	play(bank_sound, 1.0, 0.0)
	pop(total_label, merge_pop + 0.2)
	await shake_seq.do_tween_sequence()
	await wait(0.5)
	return carried


func score_one_word(entry):
	var cells = entry["cells"]

	branch_label.text = "0"
	branch_label.scale = Vector2.ONE
	centre_on(branch_label, branch_home())
	plus_fade_in.do_tween()
	branch_fade_in.do_tween()
	await wait(0.15)

	var running = 0
	for i in range(entry["steps"].size()):
		var step = entry["steps"][i]
		var previous = running
		running = step["running"]

		await reveal_letter(step["cell"], i)
		await score_letter(step, i, previous)

	# Word multipliers land only after every letter is counted.
	for m in entry["word_mults"]:
		await apply_word_multiplier(entry, m, running)
		running *= m["mult"]

	await wait(word_end_hold)
	drop_tiles(cells)

	return entry["total"]


# Beat one: the tile announces itself and fully settles before anything scores.
# reveal_seq is a sequencer, so this await is mandatory, not optional.
func reveal_letter(cell, index):
	var tile = tiles_by_cell.get(cell)
	if tile == null:
		return

	rest_popping_art(tile.art)
	tile.z_index = 200
	play(reveal_sound, 1.0 + reveal_pitch_step * index)

	reveal_seq.affected_node = tile.art
	await reveal_seq.do_tween_sequence()

	# The sequence ends at rest, so nothing is left mid-tween to clean up.
	popping_art = null
	if reveal_gap > 0.0:
		await wait(reveal_gap)


# Beat two: the number moves, and the tile reacts to its own value landing.
func score_letter(step, index, previous):
	var is_mult = step["letter_mult"] > 1
	score_pop_tile(step["cell"], is_mult)

	if is_mult:
		play(letter_mult_sound, 1.0 + 0.08 * index)
		pop(branch_label, branch_pop)
		await flash(branch_label)
		await count_to(branch_label, "%d", previous, step["running"], mult_gap * 0.6)
		await wait(mult_gap * 0.4)
	else:
		play(chip_sound, 1.0 + pitch_step * index)
		pop(branch_label, chip_pop)
		await count_to(branch_label, "%d", previous, step["running"], chip_gap * 0.6)
		await wait(chip_gap * 0.4)


# No word label to put an "x2" on, so the tile and the sound carry it.
func apply_word_multiplier(entry, m, running):
	score_pop_tile(m["cell"], true)
	play(word_mult_sound)
	pop(branch_label, word_mult_pop)
	await flash(branch_label)
	await count_to(branch_label, "%d", running, running * m["mult"], mult_gap)
	await wait(0.18)


# Anticipation, then impact. Flat merges are usually missing the first one.
func merge(new_total, branch_value):
	# Pull back away from the total before rushing in.
	await slide(slide_b, branch_label, branch_home() + Vector2(52, 0))
	play(smoosh_sound)

	# slide_a shrinks it as it travels, so it reads as being absorbed.
	slide_a.affected_node = branch_label
	slide_a.transform_tween.end_position = tally_center - branch_label.size / 2.0
	slide_a.transform_tween.end_scale = Vector2(0.35, 0.35)
	plus_fade_out.do_tween()
	await slide_a.do_tween()

	branch_label.modulate = Color(1, 1, 1, 0)
	branch_label.scale = Vector2.ONE
	if popping_label == branch_label:
		popping_label = null

	# A beat of nothing right before the hit makes the hit land.
	await wait(merge_hold)

	play(bank_sound, 1.0 + 0.04 * min(new_total / 40.0, 3.0))
	pop(total_label, merge_pop)
	shake_seq.do_tween_sequence()
	await flash(total_label)
	await count_to(total_label, "%d", new_total - branch_value, new_total, 0.3)
	await wait(0.25)
