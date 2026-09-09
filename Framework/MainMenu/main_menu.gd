class_name MainMenu extends Control

@onready var start: MainMenuButton = %Start as MainMenuButton
@onready var settings: MainMenuButton = %Settings as MainMenuButton
@onready var exit: MainMenuButton = %Exit as MainMenuButton

@onready var all_buttons : Array[MainMenuButton] = [
	start,
	settings,
	exit
]

# all buttons on left side
# on load: slide in from left
# on select: larger size, shift others up/down depending
# on click: flash color as other options slide away, then slide away

func tween_out_all_buttons() -> void:
	for button in all_buttons:
		button.do_tween_out()
	
	for button in all_buttons:
		if button.tween_out.tween == null:
			continue
		if !button.tween_out.tween.is_running():
			continue
		await button.tween_out.tween.finished


func _on_start_pressed() -> void:
	if start.release_effect.tween != null && start.release_effect.tween.is_running():
		await start.release_effect.tween.finished
	await tween_out_all_buttons()
	get_tree().quit()


func _on_settings_pressed() -> void:
	if settings.release_effect.tween != null && settings.release_effect.tween.is_running():
		await settings.release_effect.tween.finished
	await tween_out_all_buttons()
	get_tree().quit()


func _on_exit_pressed() -> void:
	if exit.release_effect.tween != null && exit.release_effect.tween.is_running():
		await exit.release_effect.tween.finished
	await tween_out_all_buttons()
	get_tree().quit()
