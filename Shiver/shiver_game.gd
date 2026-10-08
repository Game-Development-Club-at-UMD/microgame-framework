extends MicroGame

@onready var log_placer = $"Log Placer"
@onready var tree_placer = $"Tree Placer"
@onready var the_floor = $"Floor"
@onready var thermometer: TextureProgressBar = $Thermometer
@onready var campfire: CharacterBody3D = $Campfire
@onready var player: CharacterBody3D = $"Player"

@onready var survive_label: Label = $"Thermometer/WinTimer/SurviveLabel"
@onready var lose_anim_timer: Timer = $"LoseAnimTimer"

@onready var objective_label: Label = $"Instructions/CenterContainer/Objective"

@onready var sfx_wind: AudioStreamPlayer = $SfxWind
@onready var instructions: Control = $Instructions

@onready var instruction_anim: AnimationPlayer = $"Instructions/AnimationPlayer"
@onready var win_or_lose_anim: AnimationPlayer = $"WinOrLoseAnimationPlayer"

var started : bool = false

## When true, you simply can't win.
var lost: bool = false

func _ready() -> void:
	GameManager.get_node("Background").hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	the_floor.start()
	log_placer.start(self)
	tree_placer.start(self)
	
	thermometer.connect("survived", Callable(self, "win_and_quit"))
	campfire.connect("fire_gone_out", Callable(self, "initate_loss"))
	player.connect("player_started_game", Callable(self, "_on_instruction_timer_timeout"))
	
	instruction_anim.play("switch_instructions")

func initate_loss() -> void:
	if thermometer.win_sequence:
		return
	
	thermometer.game_started = false
	started = false
	lost = true
	player.lose_and_freeze_and_be_generally_sad()
	lose_anim_timer.start()
	objective_label.text = "You froze..."
	win_or_lose_anim.play("lose")
	await lose_anim_timer.timeout
	lose_and_quit()

func _on_respawner_body_entered(body: Node3D) -> void:
	body.position.y = 20

func win_and_quit() -> void:
	GameManager.get_node("Background").show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	GameManager.win()

func lose_and_quit() -> void:
	GameManager.get_node("Background").show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	GameManager.lose()

func _on_sfx_wind_finished() -> void:
	sfx_wind.play(randi_range(0,8))

## Game starts here, which now also initiates when the player starts moving. Will still initiate after a couple seconds of waiting.
func _on_instruction_timer_timeout() -> void:
	instructions.visible = false
	survive_label.show()
	thermometer.visible = true
	campfire.visible = true
	started = true

func win_sequence() -> void:
	objective_label.text = "YOU SURVIVED!"
	win_or_lose_anim.play("win")
