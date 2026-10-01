extends Node2D
## Counts down a fuse and shows the time left as text that stays upright,
## even while the ball it's attached to spins. Beeps once a second (BeepTimer),
## then twice a second once the "warning" animation takes over.

signal expired

## Seconds until the fuse runs out. Set before the node enters the tree
## (CupSpawner does this from the microgame's difficulty).
@export var duration: float = 10.0
## Below this many seconds the label starts flashing red and beeping faster.
@export var warning_time: float = 3.0

@onready var timer: Timer = $Timer
@onready var beep_timer: Timer = $BeepTimer
@onready var label: Label = $Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	timer.start(duration)
	beep_timer.start()


func _process(_delta: float) -> void:
	global_rotation = 0.0
	if timer.is_stopped():
		return
	label.text = "%.1f" % timer.time_left
	if timer.time_left <= warning_time and animation_player.current_animation != "warning":
		beep_timer.stop()
		animation_player.play("warning")


func stop() -> void:
	timer.stop()
	beep_timer.stop()
	animation_player.play("defused")


func _on_timer_timeout() -> void:
	label.text = "0.0"
	beep_timer.stop()
	animation_player.stop()
	expired.emit()
