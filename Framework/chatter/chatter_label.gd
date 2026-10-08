class_name ChatterLabel extends RichTextLabel

var is_talking : bool = false

const TEXT_SPEED : float = 0.04
const PUNCTUATION_PAUSE_AMOUNT : float = 0.2

const PAUSE_PUNCTUATION: Array[String] = [
	",",
	",",
	".",
	";",
	":",
	"!",
	"?",
	"(",
	")",
	"-",
]

signal started_talking
signal ended_talking

@export_file("*.txt") var file
@export var timer : Timer
@export var play_once : bool = false

var dialogue_lines : Array[String]

var temp_lines : Array[String]



func _ready() -> void:
	if file == null:
		printerr("%s: file is null, cannot read lines from null text file!" % self)
	dialogue_lines = ChatterParser.read_lines(file)
	reset_temp_lines()
	if !play_once:
		_on_timer_timeout()


func load_from_file() -> void:
	dialogue_lines = ChatterParser.read_lines(file)
	reset_temp_lines()


func char_causes_sentence_pause(character : String) -> bool:
	if PAUSE_PUNCTUATION.has(character):
		return true
	return false


func slowly_appear_line() -> void:
	var target_text : String = get_next_line()
	var curr_text : String = ""
	while target_text.length() > 0:
		curr_text += target_text.left(1)
		target_text = target_text.erase(0, 1)
		self.text = curr_text
		if char_causes_sentence_pause(curr_text.right(1)):
			await get_tree().create_timer(PUNCTUATION_PAUSE_AMOUNT).timeout
		await get_tree().create_timer(TEXT_SPEED).timeout


func reset_temp_lines() -> void:
	temp_lines = dialogue_lines.duplicate()
	temp_lines.shuffle()


func format_text(string : String) -> String:
	return "[shake]" + string


func get_next_line() -> String:
	if temp_lines.size() == 0:
		reset_temp_lines()
	var next_line : String = temp_lines.pop_front()
	if next_line == null:
		printerr("%s: dialogue_lines is likely empty! Check the contents of %s" % [self, file])
		return ""
	return next_line


func _on_timer_timeout() -> void:
	started_talking.emit()
	is_talking = true
	await slowly_appear_line()
	text = format_text(text)
	is_talking = false
	ended_talking.emit()
	if !play_once:
		timer.start()
