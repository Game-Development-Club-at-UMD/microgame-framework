class_name ParticleFollow extends PathFollow2D

var speed : float = 0.1

func _physics_process(delta: float) -> void:
	progress_ratio += delta * speed
