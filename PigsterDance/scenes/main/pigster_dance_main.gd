class_name PigsterDance
extends MicroGame

@export var difficulty_pools: DanceDifficultyPools
@export var transition_delay: float = 1.0

@onready var level_animation_player = %LevelAnimationPlayer
@onready var label_timer = $LabelTimer
@onready var start_text = $StageUI/StartText
@onready var qte_handler = $QteHandler
@onready var dance_qte = $QteHandler/DanceQte

var level_stats: DanceLevelStats

signal stage_set

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	dance_qte.hide()
	stage_set.connect(_start_game)
	dance_qte.qte_won.connect(_on_dance_qte_won)
	dance_qte.qte_failed.connect(_on_dance_qte_failed)
	_set_difficulty()
	_set_the_stage()

func _set_difficulty() -> void:
	if difficulty <= 0.3:
		level_stats = _set_level_stats(difficulty_pools.easy_pool)
	elif difficulty > 0.3 and difficulty < 0.6:
		level_stats = _set_level_stats(difficulty_pools.medium_pool)
	else:
		level_stats = _set_level_stats(difficulty_pools.hard_pool)
	
	# Send the current level stats to the DanceQte
	dance_qte.current_level_stats = level_stats

func _set_level_stats(difficulty_pool: Array[DanceLevelStats]) -> DanceLevelStats:
	var new_stats = difficulty_pool.pick_random()
	return new_stats

# Plays the animation at the start of the level
func _set_the_stage() -> void:
	level_animation_player.play("level_start")
	_show_start_text()


func _show_start_text() -> void:
	await level_animation_player.animation_finished
	label_timer.start(0.7)
	await label_timer.timeout
	start_text.show()
	label_timer.start(0.7)
	await label_timer.timeout
	start_text.hide()
	await get_tree().create_timer(transition_delay).timeout
	stage_set.emit()


func _start_game() -> void:
	dance_qte.show()
	await get_tree().create_timer(transition_delay).timeout
	dance_qte.start_qte()


func _on_dance_qte_won() -> void:
	_show_result_text("qte won")
	await get_tree().create_timer(transition_delay).timeout
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	GameManager.win()


func _on_dance_qte_failed() -> void:
	_show_result_text("qte dance failed")
	await get_tree().create_timer(transition_delay).timeout
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	GameManager.lose()


func _show_result_text(text: String) -> void:
	start_text.text = text
	start_text.show()
