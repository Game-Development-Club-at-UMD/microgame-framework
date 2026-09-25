class_name PauseMenu extends Node

@onready var gradient: TextureRect = %Gradient
@onready var resume: MainMenuButton = %Resume as MainMenuButton
@onready var exit: MainMenuButton = %Exit as MainMenuButton
# tweens
@onready var fade_in: ControlTween = %FadeIn as ControlTween
@onready var fade_out: ControlTween = %FadeOut as ControlTween

@onready var buttons : Array[MainMenuButton] = [
	resume,
	exit
]

const MAIN_MENU = preload("uid://da4hhvghhnoi8")


func _ready() -> void:
	gradient.modulate = Color.TRANSPARENT
	open_pause_menu()


func close_pause_menu(button_pressed : MainMenuButton = resume) -> void:
	fade_out.do_tween()
	await MainMenuButton.outro_all_buttons(button_pressed, buttons)
	GameManager.unpause_game()
	# Hide the mouse icon when closing the pause menu
	GameManager.mouse_paw.make_invisible()
	self.queue_free()


func open_pause_menu() -> void:
	GameManager.pause_game()
	fade_in.do_tween()
	# Show the mouse icon while in pause menu
	GameManager.mouse_paw.make_visible()
	# stagger buttons on begin
	await MainMenuButton.intro_all_buttons(buttons)


func _on_resume_pressed() -> void:
	await close_pause_menu(resume)


func _on_exit_pressed() -> void:
	await close_pause_menu(exit)
	GameManager.switch_scene_to_packed(MAIN_MENU)
	GameManager.mouse_paw.make_visible()
