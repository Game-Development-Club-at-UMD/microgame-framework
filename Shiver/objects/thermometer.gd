extends TextureProgressBar

@export var game: MicroGame

@onready var timer_label: Label = $WinTimer/TimerLabel
var win_counter : int = 30

var value_ticker : float = 1
var game_started : bool = false
var win_sequence : bool = false

@onready var win_timer: Timer = $WinTimer
@export var campfire: Node3D

## value of 50 corresponds roughly to needing to survive 50 secs
@export var timer_slowdown_strength : int = 30
var heatup_time : int = 4
signal survived

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not game_started:
		return
	elif win_sequence:
		value_ticker += delta / heatup_time
		value = value_ticker
		tint_progress = Color(1,1-value_ticker,1-value_ticker,1)
		
		if not animation_player.is_playing():
			#animation_player.play("player_won")
			game.win_sequence()
		
		if value_ticker >= 1:
			survived.emit()
		return
	
	if win_timer.is_stopped():
		win_timer.start()
		timer_label.visible = true
	
	value_ticker = campfire.temp
	value = value_ticker
	tint_progress = Color(1-value_ticker,1-value_ticker,1,1)
	


func _on_visibility_changed() -> void:
	game_started = true



func _on_win_timer_timeout() -> void:
	animation_player.play("TimerJuice")
	if game.lost:
		win_timer.stop()
	elif win_counter == 0:
		win_sequence = true
		win_timer.stop()
		value_ticker = 0
		game.campfire.stop_shrinking()
	else:
		win_counter -= 1
		timer_label.text = str(win_counter)
	
	
