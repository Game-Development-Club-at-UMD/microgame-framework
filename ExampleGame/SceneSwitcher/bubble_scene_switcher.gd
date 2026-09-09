extends MicroGame

const BUBBLE_GAME = preload("uid://wimvir2g37io")
const LEVEL_1_EASY_ = preload("uid://dcsrmlrnv8ulg")
const LEVEL_1_HARD_ = preload("uid://cleldepj8048d")
const LEVEL_2_EASY_ = preload("uid://cu3k1a148d31m")
const LEVEL_2_HARD_ = preload("uid://56gmtyinnce7")
const LEVEL_3_EASY_ = preload("uid://7uonwuc45ak")
const LEVEL_3_HARD_ = preload("uid://bwjsk2dc7wv7g")
const LEVEL_4_EASY_ = preload("uid://dmtd1rp4tuu2w")
const LEVEL_4_HARD_ = preload("uid://dpppnytk22gc6")
const MOUSE_CURSOR = preload("uid://bog33u2o2xq6k")

var easy_levels : Array[PackedScene] = [LEVEL_1_EASY_, LEVEL_2_EASY_, LEVEL_3_EASY_, LEVEL_4_EASY_]
var hard_levels : Array[PackedScene] = [LEVEL_1_HARD_, LEVEL_2_HARD_, LEVEL_3_HARD_, LEVEL_4_HARD_]
var time : float = 10.0
var max_time : float
var current_scene : PackedScene
var won_levels : int = 0
var levels_to_win : int = 3

var in_transition : bool = true

@onready var appear: ControlTween = $FadeScreen/FadePlayer/Appear
@onready var disappear: ControlTween = $FadeScreen/FadePlayer/Disappear
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar as TextureProgressBar
@onready var timer: Timer = $Timer as Timer
@onready var time_left_notifier: ControlTweenSequencer = $TextureProgressBar/TimeLeftNotifier as ControlTweenSequencer
@onready var fade_player: ControlTweenSequencer = $FadeScreen/FadePlayer as ControlTweenSequencer
@onready var introduction_screen: BubbleInstructionScreen = $IntroductionScreen as BubbleInstructionScreen


func _ready() -> void:
	Input.set_custom_mouse_cursor(MOUSE_CURSOR)
	introduction_screen.do_introduction()
	max_time = time * 100 * 2
	texture_progress_bar.max_value = max_time
	timer.start(time)
	introduction_screen.can_start.connect(start_round)
	


func start_round() -> void:
	await switch_scene(easy_levels.pick_random(), null, true)
	in_transition = false


#region scene switching
func switch_scene(new_scene : PackedScene, old_scene : Node, initial : bool = false) -> bool:
	# fading out
	if !initial:
		appear.do_tween()
		await appear.tween.finished
		in_transition = true
	# deleting old scene
	
	if old_scene != null:
		old_scene.queue_free()
		if old_scene.is_inside_tree():
			await old_scene.tree_exited
	# adding new scene
	var bubble_game : BubbleGame = new_scene.instantiate() as BubbleGame
	current_scene = new_scene
	# binding bubble_game to scene switching request so that we dont have to do signal.emit(self)
	bubble_game.reload_scene.connect(_on_reload_scene_request.bind(bubble_game))
	bubble_game.switch_to_new_scene.connect(_on_switch_scene_request.bind(bubble_game))
	add_child(bubble_game)
	# fading in
	if !initial:
		disappear.do_tween()
		await disappear.tween.finished
		in_transition = false
	return true


func _on_reload_scene_request(old_scene : Node) -> void:
	await switch_scene(current_scene, old_scene)


func _on_switch_scene_request(old_scene : Node) -> void:
	hard_levels.shuffle()
	var new_scene : PackedScene = hard_levels.pop_front()
	timer.start(time)
	won_levels += 1
	if won_levels >= levels_to_win:
		win_game()
		return
	await switch_scene(new_scene, old_scene)
	timer.start(time)
	
#endregion

#region game win/lose state
func _process(_delta: float) -> void:
	if in_transition == true:
		timer.paused = true
		return
	else:
		timer.paused = false
	
	texture_progress_bar.value = timer.time_left * 100 * 2
	if (
		int(texture_progress_bar.value) % int(max_time / 4) >= -10 and 
		int(texture_progress_bar.value) % int(max_time / 4) <= 10
		):
		time_left_notifier.do_tween_sequence()


func win_game():
	GameManager.win()


func lose_game():
	GameManager.lose()


func _on_timer_timeout() -> void:
	lose_game()
#endregion
