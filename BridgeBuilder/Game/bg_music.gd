extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if stream:
		var audio_length : float = stream.get_length()
		var random_start_time : float = randf_range(0.0, audio_length)
		play(random_start_time)
