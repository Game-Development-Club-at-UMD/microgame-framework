class_name SHOOTHIMNOTME extends MicroGame

var imposter = randi_range(0, 1)
var belt = randi_range(0, 1)
var eyes = randi_range(0, 3)
var hair = randi_range(0, 3)
var hatband = randi_range(0, 3)
var shoes = randi_range(0, 1)
var tie = randi_range(0, 3)
var hints = ["Belt", "Eyes", "Hair", "Hatband", "Shoes", "Tie"]
var time = 3.0
var timer_on = false
var start = false
var can_start = false
var ready_to_shoot = false
var choice = 0

func _ready() -> void:
	feature_randomize()
	spagetti_code()
	await get_tree().create_timer(0.1, false).timeout
	$Instructions.visible = true
	$Instructions2.visible = true
	can_start = true

func _process(delta: float) -> void:
	if timer_on:
		time -= delta
		$Countdown.text = time_to_string()
	else: 
		return
		
	if time <= 0 and ready_to_shoot:
		ready_to_shoot = false
		shoot_gun()
		
func shoot_gun():
	$Countdown.visible = false
	if choice == imposter and imposter == 0:
		$PewPew.play()
		if true:
			$FrankLeft/Frank/Belt.visible = false
			$FrankLeft/Frank/Eyes.visible = false
			$FrankLeft/Frank/Hair.visible = false
			$FrankLeft/Frank/Hatband.visible = false
			$FrankLeft/Frank/Shoes.visible = false
			$FrankLeft/Frank/Tie.visible = false
		$FrankLeft/Frank.set_frame_and_progress(1, 0)
		await get_tree().create_timer(0.5, false).timeout
		$Instructions3.visible = true
		await get_tree().create_timer(0.5, false).timeout
		GameManager.win()
		await get_tree().create_timer(0.9, false).timeout
		get_tree().reload_current_scene()

	elif choice == imposter and imposter == 1:
		$PewPew.play()
		if true:
			$FrankRight/Frank2/Belt.visible = false
			$FrankRight/Frank2/Eyes.visible = false
			$FrankRight/Frank2/Hair.visible = false
			$FrankRight/Frank2/Hatband.visible = false
			$FrankRight/Frank2/Shoes.visible = false
			$FrankRight/Frank2/Tie.visible = false
		$FrankRight/Frank2.set_frame_and_progress(1, 0)
		await get_tree().create_timer(0.5, false).timeout
		$Instructions3.visible = true
		await get_tree().create_timer(0.5, false).timeout
		GameManager.win()
		await get_tree().create_timer(0.9, false).timeout
		get_tree().reload_current_scene()

	else:
		$Yoxuuxdiixxe.visible = true
		$PewPew.play()
		$Scarylose.play()
		await get_tree().create_timer(1, false).timeout
		GameManager.lose()
		await get_tree().create_timer(0.9, false).timeout
		get_tree().reload_current_scene()
		

func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("left_click") and start == false and can_start:
		start = true
		start_game()
	
	if Input.is_action_pressed("left_click") and ready_to_shoot:
		ready_to_shoot = false
		shoot_gun()
		

func start_game():
	$Instructions.visible = false
	$Instructions2.visible = false
	$Countdown.visible = true
	var available_hints = hints.slice(0, 3)
	var _show_hint = 100
	available_hints.shuffle()
	
	await get_tree().create_timer(0.05, false).timeout
	timer_on = true
	if true:
		if available_hints[0] == "Belt":
			$Hints/Belt.visible = true
		if available_hints[0] == "Eyes":
			$Hints/Eyes.visible = true
		if available_hints[0] == "Hair":
			$Hints/Hair.visible = true
		if available_hints[0] == "Hatband":
			$Hints/Hatband.visible = true
		if available_hints[0] == "Shoes":
			$Hints/Shoes.visible = true
		if available_hints[0] == "Tie":
			$Hints/Tie.visible = true
	available_hints.pop_front()
	
	await get_tree().create_timer(1, false).timeout
	if true:
		$Hints/Belt.visible = false
		$Hints/Eyes.visible = false
		$Hints/Hair.visible = false
		$Hints/Hatband.visible = false
		$Hints/Shoes.visible = false
		$Hints/Tie.visible = false
	if true:
		if available_hints[0] == "Belt":
			$Hints/Belt.visible = true
		if available_hints[0] == "Eyes":
			$Hints/Eyes.visible = true
		if available_hints[0] == "Hair":
			$Hints/Hair.visible = true
		if available_hints[0] == "Hatband":
			$Hints/Hatband.visible = true
		if available_hints[0] == "Shoes":
			$Hints/Shoes.visible = true
		if available_hints[0] == "Tie":
			$Hints/Tie.visible = true
	available_hints.pop_front()
	
	await get_tree().create_timer(1, false).timeout
	if true:
		$Hints/Belt.visible = false
		$Hints/Eyes.visible = false
		$Hints/Hair.visible = false
		$Hints/Hatband.visible = false
		$Hints/Shoes.visible = false
		$Hints/Tie.visible = false
	if true:
		if available_hints[0] == "Belt":
			$Hints/Belt.visible = true
		if available_hints[0] == "Eyes":
			$Hints/Eyes.visible = true
		if available_hints[0] == "Hair":
			$Hints/Hair.visible = true
		if available_hints[0] == "Hatband":
			$Hints/Hatband.visible = true
		if available_hints[0] == "Shoes":
			$Hints/Shoes.visible = true
		if available_hints[0] == "Tie":
			$Hints/Tie.visible = true
	available_hints.pop_front()
	
	await get_tree().create_timer(1, false).timeout
	ready_to_shoot = true
	if true:
		$Hints/Belt.visible = false
		$Hints/Eyes.visible = false
		$Hints/Hair.visible = false
		$Hints/Hatband.visible = false
		$Hints/Shoes.visible = false
		$Hints/Tie.visible = false
	$Background.visible = false
	time = 2
	

func time_to_string() -> String:
	var msecond = clampf(fmod(time, 1) * 100, 0, 100)
	var second = clampf(fmod(time, 60), 0, 30)
	var format_string = "%01d : %02d"
	var actual_string = format_string % [second, msecond]
	return actual_string

func feature_randomize():
	$FrankLeft/Frank/Belt.set_frame_and_progress(belt, 0)
	$FrankLeft/Frank/Eyes.set_frame_and_progress(eyes, 0)
	$FrankLeft/Frank/Hair.set_frame_and_progress(hair, 0)
	$FrankLeft/Frank/Hatband.set_frame_and_progress(hatband, 0)
	$FrankLeft/Frank/Shoes.set_frame_and_progress(shoes, 0)
	$FrankLeft/Frank/Tie.set_frame_and_progress(tie, 0)
	$FrankRight/Frank2/Belt.set_frame_and_progress(belt, 0)
	$FrankRight/Frank2/Eyes.set_frame_and_progress(eyes, 0)
	$FrankRight/Frank2/Hair.set_frame_and_progress(hair, 0)
	$FrankRight/Frank2/Hatband.set_frame_and_progress(hatband, 0)
	$FrankRight/Frank2/Shoes.set_frame_and_progress(shoes, 0)
	$FrankRight/Frank2/Tie.set_frame_and_progress(tie, 0)
	$Hints/Belt.set_frame_and_progress(belt, 0)
	$Hints/Eyes.set_frame_and_progress(eyes, 0)
	$Hints/Hair.set_frame_and_progress(hair, 0)
	$Hints/Hatband.set_frame_and_progress(hatband, 0)
	$Hints/Shoes.set_frame_and_progress(shoes, 0)
	$Hints/Tie.set_frame_and_progress(tie, 0)

func spagetti_code():
	hints.shuffle()
	var imposter_mistake = hints.slice(0,1)
	var belt_mistake = randi_range(0, 1)
	var eyes_mistake = randi_range(0, 3)
	var hair_mistake = randi_range(0, 3)
	var hatband_mistake = randi_range(0, 3)
	var shoes_mistake = randi_range(0, 1)
	var tie_mistake = randi_range(0, 3)
	if true:
		if imposter_mistake.has("Belt") and imposter == 0:
			while belt_mistake == belt:
				belt_mistake = randi_range(0, 1)
			$FrankLeft/Frank/Belt.set_frame_and_progress(belt_mistake, 0)
		if imposter_mistake.has("Eyes") and imposter == 0:
			while eyes_mistake == eyes:
				eyes_mistake = randi_range(0, 1)
			$FrankLeft/Frank/Eyes.set_frame_and_progress(eyes_mistake, 0)
		if imposter_mistake.has("Hair") and imposter == 0:
			while hair_mistake == hair:
				hair_mistake = randi_range(0, 1)
			$FrankLeft/Frank/Hair.set_frame_and_progress(hair_mistake, 0)
		if imposter_mistake.has("Hatband") and imposter == 0:
			while hatband_mistake == hatband:
				hatband_mistake = randi_range(0, 1)
			$FrankLeft/Frank/Hatband.set_frame_and_progress(hatband_mistake, 0)
		if imposter_mistake.has("Shoes") and imposter == 0:
			while shoes_mistake == shoes:
				shoes_mistake = randi_range(0, 1)
			$FrankLeft/Frank/Shoes.set_frame_and_progress(shoes_mistake, 0)
		if imposter_mistake.has("Tie") and imposter == 0:
			while tie_mistake == tie:
				tie_mistake = randi_range(0, 1)
			$FrankLeft/Frank/Tie.set_frame_and_progress(tie_mistake, 0)
		if imposter_mistake.has("Belt") and imposter == 1:
			while belt_mistake == belt:
				belt_mistake = randi_range(0, 1)
			$FrankRight/Frank2/Belt.set_frame_and_progress(belt_mistake, 0)
		if imposter_mistake.has("Eyes") and imposter == 1:
			while eyes_mistake == eyes:
				eyes_mistake = randi_range(0, 1)
			$FrankRight/Frank2/Eyes.set_frame_and_progress(eyes_mistake, 0)
		if imposter_mistake.has("Hair") and imposter == 1:
			while hair_mistake == hair:
				hair_mistake = randi_range(0, 1)
			$FrankRight/Frank2/Hair.set_frame_and_progress(hair_mistake, 0)
		if imposter_mistake.has("Hatband") and imposter == 1:
			while hatband_mistake == hatband:
				hatband_mistake = randi_range(0, 1)
			$FrankRight/Frank2/Hatband.set_frame_and_progress(hatband_mistake, 0)
		if imposter_mistake.has("Shoes") and imposter == 1:
			while shoes_mistake == shoes:
				shoes_mistake = randi_range(0, 1)
			$FrankRight/Frank2/Shoes.set_frame_and_progress(shoes_mistake, 0)
		if imposter_mistake.has("Tie") and imposter == 1:
			while tie_mistake == tie:
				tie_mistake = randi_range(0, 1)
			$FrankRight/Frank2/Tie.set_frame_and_progress(tie_mistake, 0)

func _on_choice_area_left_mouse_entered() -> void:
	choice = 0
	$Gun.set_frame_and_progress(choice, 0)

func _on_choice_area_left_mouse_exited() -> void:
	choice = 2
	$Gun.set_frame_and_progress(choice, 0)

func _on_choice_area_right_mouse_entered() -> void:
	choice = 1
	$Gun.set_frame_and_progress(choice, 0)

func _on_choice_area_right_mouse_exited() -> void:
	choice = 2
	$Gun.set_frame_and_progress(choice, 0)
