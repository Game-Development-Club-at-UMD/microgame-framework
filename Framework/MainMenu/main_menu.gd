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
		button.play_tween_in()


func tween_out_all_buttons(exception : MainMenuButton) -> void:
	if !exception.tween_out_queued:
		await get_tree().process_frame
		await exception.watched_release_tween.finished
	
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
	
	if !exception.tween_out_already_finished:
		await exception.tween_out_finished


func _on_start_pressed() -> void:
	await tween_out_all_buttons(start)
	get_tree().quit()


func _on_settings_pressed() -> void:
	await tween_out_all_buttons(settings)
	get_tree().quit()


func _on_exit_pressed() -> void:
	await tween_out_all_buttons(exit)
	get_tree().quit()
