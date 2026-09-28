class_name RaceTrackLevel
extends Node2D

signal level_completed
signal level_failed

#how long the end level stays on screen before moving on
@export var end_screen_time: float = 1.0

@onready var fade_rect = $FadeLayer/FadeRect
@onready var character_handler: CharacterHandler = $CharacterHandler
@onready var explosion = %Explosion
@onready var track_path: Path2D = $TrackPath
@onready var car_follow: PathFollow2D = $TrackPath/CarFollow
@onready var fail_path_handler: FailPathHandler = $FailPathHandler
@onready var qte = $GameUI/QTE
@onready var qte_timer: Timer = $QteTimer
@onready var countdown_label: Label = $GameUI/CountdownLabel
@onready var game_over_panel = $GameUI/GameOverPanel
@onready var game_over_title = $GameUI/GameOverPanel/VBoxContainer/GameOverTitle
@onready var game_over_label = $GameUI/GameOverPanel/VBoxContainer/GameOverLabel
@onready var racecar = $TrackPath/CarFollow/Racecar

@export var racetrack_stats: RacetrackLevelStats
# Used instead of racetrack_stats when difficulty is above 0.0 (random pick)
@export var racetrack_stats_pool: Array[RacetrackLevelStats]
@export var fade_duration: float = 0.8

var _waiting_for_qte := false
var _false_started := false
var local_difficulty_scale: float = 1.0
var global_difficulty: float

func _ready() -> void:
	_set_difficulty()
	_select_racetrack_stats()
	_fade_in()
	var track_anchors := _compute_checkpoint_anchors(racetrack_stats.checkpoints)
	
	character_handler.spawn_characters(track_anchors)
	fail_path_handler.build_fail_paths(track_anchors, character_handler.characters)
	
	qte_timer.one_shot = true
	run_game()


func _input(event: InputEvent) -> void:
	if not _waiting_for_qte:
		return
	if event is InputEventKey and event.pressed and not event.is_echo() and event.keycode == KEY_SPACE:
		_waiting_for_qte = false
		_false_started = true
		qte_timer.stop()
		qte_timer.timeout.emit()


func run_game() -> void:
	await _run_countdown()
	
	for i in racetrack_stats.checkpoints.size():
		var success: bool = await _run_checkpoint(racetrack_stats.checkpoints[i])
		if not success:
			_handle_fail(i, _false_started)
			return
	
	_handle_win()


func _run_countdown() -> void:
	await _fade_in()
	countdown_label.show()
	for text in ["3", "2", "1", "Go!"]:
		countdown_label.text = text
		await get_tree().create_timer(0.7).timeout
	countdown_label.hide()


func _run_checkpoint(data: CheckpointData) -> bool:
	_false_started = false
	_waiting_for_qte = true
	
	# Randomized delay before the QTE triggers
	qte_timer.wait_time = randf_range(racetrack_stats.min_delay, racetrack_stats.max_delay)
	qte_timer.start()
	await qte_timer.timeout
	
	_waiting_for_qte = false
	if _false_started:
		return false
	
	qte.event_duration = data.qte_duration * local_difficulty_scale
	qte.start()
	var success: bool = await qte.finished
	
	if success:
		var tween := create_tween()
		tween.tween_property(car_follow, "progress_ratio", data.success_ratio, 0.6)\
			.set_ease(Tween.EASE_IN_OUT)
		await tween.finished
	
	return success

func _handle_fail(checkpoint_index: int, false_start := false) -> void:
	var fail_path := fail_path_handler.fail_paths[checkpoint_index]
	var character := character_handler.characters[checkpoint_index]
	
	# Reparent the follow node onto the generated fail curve
	track_path.remove_child(car_follow)
	fail_path.add_child(car_follow)
	car_follow.progress_ratio = 0.0
	
	var tween := create_tween()
	tween.tween_property(car_follow, "progress_ratio", 1.0, 0.6)
	await tween.finished
	
	explosion.play("explode")
	character.play("death")
	racecar.queue_free()
	await character.animation_finished
	character.queue_free()
	
	await get_tree().create_timer(0.7).timeout
	game_over_panel.visible = true
	game_over_title.text = "CRASHED!"
	game_over_label.text = "TOO EARLY, BUCKO!" if false_start else "Bad news... You're DEAD!"
	
	await get_tree().create_timer(end_screen_time).timeout
	level_failed.emit()


func _handle_win() -> void:
	await get_tree().create_timer(0.7).timeout
	game_over_panel.visible = true
	game_over_title.text = "SUCCESS!"
	game_over_label.text = "You sure know how to drive!"

	await get_tree().create_timer(end_screen_time).timeout
	level_completed.emit()

func _compute_checkpoint_anchors(checkpoints: Array[CheckpointData]) -> Array[Transform2D]:
	var anchors: Array[Transform2D] = []
	var curve := track_path.curve
	var baked_length := curve.get_baked_length()
	
	var previous_ratio := 0.0
	for checkpoint in checkpoints:
		var offset := previous_ratio * baked_length
		var local_point: Vector2 = curve.sample_baked(offset)
		var local_direction := _sample_track_direction(curve, offset, baked_length)
	
		var global_point := track_path.to_global(local_point)
		var global_direction := track_path.get_global_transform().basis_xform(local_direction).normalized()
	
		anchors.append(Transform2D(global_direction.angle(), global_point))
	
		previous_ratio = checkpoint.success_ratio
	
	return anchors


func _sample_track_direction(curve: Curve2D, offset: float, baked_length: float) -> Vector2:
	const STEP := 4.0
	var forward_offset :float= min(offset + STEP, baked_length)
	var backward_offset :float= max(offset - STEP, 0.0)
	
	if is_equal_approx(forward_offset, backward_offset):
		return Vector2.RIGHT 
	
	var forward_point: Vector2 = curve.sample_baked(forward_offset)
	var backward_point: Vector2 = curve.sample_baked(backward_offset)
	return (forward_point - backward_point).normalized()

func _set_difficulty() -> void:
	if global_difficulty == 0:
		return
	
	local_difficulty_scale = 1.2 - global_difficulty

func _fade_in() -> void:
	fade_rect.color.a = 1.0
	var tween := create_tween()
	tween.tween_property(fade_rect, "color:a", 0.0, fade_duration)
	await tween.finished

func _select_racetrack_stats() -> void:
	if global_difficulty == 0.0 or racetrack_stats_pool.is_empty():
		return
	
	racetrack_stats = racetrack_stats_pool.pick_random()
