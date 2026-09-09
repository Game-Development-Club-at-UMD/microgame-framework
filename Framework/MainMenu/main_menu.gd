class_name MainMenu extends Control

@onready var start: MainMenuButton = %Start as MainMenuButton
@onready var settings: MainMenuButton = %Settings as MainMenuButton
@onready var exit: MainMenuButton = %Exit as MainMenuButton

@onready var all_buttons : Array[MainMenuButton] = [
	start,
	settings,
	exit
]


func _ready() -> void:
	for button in all_buttons:
		# dont delay first button tween
		if button != all_buttons.get(0):
			await get_tree().create_timer(0.3).timeout
		button.play_intro()


func outro_all_buttons(exception : MainMenuButton) -> void:
	if !exception.outro_queued:
		await get_tree().process_frame
		await exception.watched_release_tween.finished
	
	for button in all_buttons:
		if button == exception:
			continue
		button.do_outro()
	
	for button in all_buttons:
		if button == exception:
			continue
		if button.outro.tween == null:
			continue
		if !button.outro.tween.is_running():
			continue
		await button.outro.tween.finished
	
	if !exception.outro_already_finished:
		await exception.outro_finished


func _on_start_pressed() -> void:
	await outro_all_buttons(start)
	get_tree().quit()


func _on_settings_pressed() -> void:
	await outro_all_buttons(settings)
	get_tree().quit()


func _on_exit_pressed() -> void:
	await outro_all_buttons(exit)
	get_tree().quit()
