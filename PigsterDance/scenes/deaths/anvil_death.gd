class_name AnvilDeath
extends DanceDeath

@export var drop_height: float = 700.0
@export var drop_time: float = 0.35
@export var linger_time: float = 1.5

@onready var anvil: Sprite2D = $Anvil
@onready var anvil_player: AudioStreamPlayer = $AnvilPlayer

func start(target_position: Vector2) -> void:
	anvil.global_position = target_position - Vector2(0, drop_height)
	anvil.show()
	
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property(anvil, "global_position", target_position, drop_time)
	await tween.finished
	
	anvil_player.play()
	impact.emit(target_position, Vector2.DOWN)
	await get_tree().create_timer(linger_time).timeout
	finished.emit()
