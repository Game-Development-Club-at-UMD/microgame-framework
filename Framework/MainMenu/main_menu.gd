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

func tween_out_all_buttons(exception : MainMenuButton) -> void:
	for button in all_buttons:
		#button.quit_queued = true
		if button == exception:
			continue
		button.do_tween_out()
	
	for button in all_buttons:
		if button == exception:
			continue
		if button.tween_out.tween == null:
			continue
		if !button.tween_out.tween.is_running():
			continue
		await button.tween_out.tween.finished


func _on_start_pressed() -> void:
	await tween_out_all_buttons(start)
	if start.release_effect.tween != null && start.release_effect.tween.is_running():
		await start.release_effect.tween.finished
	start.do_tween_out()
	await start.tween_out.tween.finished
	get_tree().quit()


func _on_settings_pressed() -> void:
	await tween_out_all_buttons(settings)
	if settings.release_effect.tween != null && settings.release_effect.tween.is_running():
		await settings.release_effect.tween.finished
	settings.do_tween_out()
	await settings.tween_out.tween.finished
	get_tree().quit()


func _on_exit_pressed() -> void:
	await tween_out_all_buttons(exit)
	if exit.release_effect.tween != null && exit.release_effect.tween.is_running():
		await exit.release_effect.tween.finished
	exit.do_tween_out()
	await exit.tween_out.tween.finished
	get_tree().quit()
