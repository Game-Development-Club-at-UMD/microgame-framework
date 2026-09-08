extends Node

@onready var _fade_to_black: ControlTween = %FadeToBlack
@onready var _fade_from_black: ControlTween = %FadeFromBlack

func switch_scene(next_scene : PackedScene) -> void:
	_fade_to_black.do_tween()
	await _fade_to_black.tween.finished
	
	get_tree().change_scene_to_packed(next_scene)
	
	_fade_from_black.do_tween()
	await _fade_from_black.tween.finished


func lose() -> void:
	pass


func win() -> void:
	pass


# TODO: replace this with saving highscore
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit()
