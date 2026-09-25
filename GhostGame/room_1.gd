extends Node2D

var ghostChoice: int = randi_range(0, 3)
signal ghostLoseByeBye
var soundPlayed: bool = false

@onready var jumpScareAnimationPlayer: AnimationPlayer = $LoseJumpscare/AnimationPlayer


var timer: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = 30 * (1 - GameManager.difficulty_manager.current_difficulty)
	if timer <= 10:
		timer = 10
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer -= delta
	if timer > 0:
		$Label.text = str(ceili(timer))
	if timer <= 0:
		$Ambience.stop()
		if soundPlayed == false:
			$LoseJumpscare/Roar.play()
			soundPlayed = true
		ghostLoseByeBye.emit()
		emit_signal("ghostLoseByeBye")
		jumpScareAnimationPlayer.play("Jumpscare")
		get_tree().create_timer(1.0, false)
		GameManager.lose()
