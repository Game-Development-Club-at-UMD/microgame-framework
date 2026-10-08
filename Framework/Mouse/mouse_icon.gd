class_name PawMouseIcon extends Node

@onready var mouse_animator: AnimationPlayer = $MouseAnimator as AnimationPlayer
const SIWWY_WIDDLE_GUY_PAW_1 = preload("uid://m8s5co63k7ex")
const SIWWY_WIDDLE_GUY_PAW_2 = preload("uid://dy8yiilqufo7f")

var current_mouse_uid : String = ''
var current_mouse_texture : Texture2D = null
var previous_mouse_texture : Texture2D = null




func get_previous_mouse_icon() -> void:
	current_mouse_uid = ProjectSettings.get_setting("display/mouse_cursor/custom_image") as String
	current_mouse_texture = load(current_mouse_uid) as Texture2D
	
	previous_mouse_texture = current_mouse_texture


func set_previous_mouse_icon() -> void:
	mouse_animator.stop()
	get_previous_mouse_icon()
	if previous_mouse_texture == SIWWY_WIDDLE_GUY_PAW_1 or previous_mouse_texture == SIWWY_WIDDLE_GUY_PAW_2:
		mouse_animator.play("AnimatePaw")
	Input.set_custom_mouse_cursor(previous_mouse_texture)


func set_paw_mouse() -> void:
	mouse_animator.play("AnimatePaw")


func set_new_mouse_icon(mouse_icon : Texture2D) -> void:
	Input.set_custom_mouse_cursor(mouse_icon)
