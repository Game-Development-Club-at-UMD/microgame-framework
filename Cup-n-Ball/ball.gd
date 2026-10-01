extends RigidBody2D
## Cup-n-Ball ball. Carries a fuse; blows up if the fuse runs out, or bursts into
## confetti after the cup catches it and charges it up.

## Emitted once the pop effect has finished playing.
signal popped(won: bool)

enum State { LIVE, CAUGHT, POPPED }

var state := State.LIVE

@onready var visual: Node2D = $Visual
@onready var fuse_timer: Node2D = $FuseTimer
@onready var explosion: Node2D = $Explosion
@onready var confetti_burst: Node2D = $ConfettiBurst


func is_live() -> bool:
	return state == State.LIVE


## FuseTimer.expired -> boom.
func explode() -> void:
	if state != State.LIVE:
		return
	_pop()
	explosion.detonate(global_position)


## CupDetector.ball_caught -> stop the fuse while the cup zaps the ball.
func on_caught(_ball: RigidBody2D) -> void:
	if state != State.LIVE:
		return
	state = State.CAUGHT
	fuse_timer.stop()


## ElectricZap.finished -> confetti.
func burst_confetti() -> void:
	if state != State.CAUGHT:
		return
	_pop()
	confetti_burst.burst(global_position)


func _on_explosion_finished() -> void:
	popped.emit(false)


func _on_confetti_burst_finished() -> void:
	popped.emit(true)


# Hide the ball but leave it hanging on the string as an invisible weight.
func _pop() -> void:
	state = State.POPPED
	visual.hide()
	fuse_timer.hide()
	set_deferred("collision_layer", 0)
	set_deferred("collision_mask", 0)
