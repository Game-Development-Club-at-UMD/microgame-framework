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


func _ready() -> void:
	for button in all_buttons:
		# dont delay first button tween
		if button != all_buttons.get(0):
			await get_tree().create_timer(0.3).timeout
		button.play_tween_in()


func tween_out_all_buttons(exception : MainMenuButton) -> void:
	for button in all_buttons:
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


func handle_button_press(button : MainMenuButton) -> void:
	await tween_out_all_buttons(button)
	if button.release_effect.tween != null && button.release_effect.tween.is_running():
		await button.release_effect.tween.finished
	button.do_tween_out()
	await button.tween_out.tween.finished


func _on_start_pressed() -> void:
	await handle_button_press(start)
	get_tree().quit()


func _on_settings_pressed() -> void:
	await handle_button_press(settings)
	get_tree().quit()


func _on_exit_pressed() -> void:
	await handle_button_press(exit)
	get_tree().quit()
