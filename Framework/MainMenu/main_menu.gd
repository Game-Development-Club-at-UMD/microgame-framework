class_name MainMenu extends Control

@onready var start: MainMenuButton = %Start as MainMenuButton
@onready var settings: MainMenuButton = %Settings as MainMenuButton
@onready var exit: MainMenuButton = %Exit as MainMenuButton

@onready var buttons : Array[MainMenuButton] = [
	start,
	settings,
	exit
]


func _ready() -> void:
	# stagger buttons on begin
	MainMenuButton.intro_all_buttons(buttons)


func _on_start_pressed() -> void:
	await MainMenuButton.outro_all_buttons(start, buttons)
	GameManager.start_microgame()


func _on_settings_pressed() -> void:
	await MainMenuButton.outro_all_buttons(settings, buttons)
	get_tree().quit()


func _on_exit_pressed() -> void:
	await MainMenuButton.outro_all_buttons(exit, buttons)
	get_tree().quit()
