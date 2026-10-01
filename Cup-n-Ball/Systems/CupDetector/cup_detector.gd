extends Area2D
## Sits in the bottom of the cup's basin. A live ball that drops in from above and
## stays for SettleTimer's wait_time counts as caught (so a quick bounce off the rim
## doesn't count).

signal ball_caught(ball: RigidBody2D)

var candidate: RigidBody2D

@onready var settle_timer: Timer = $SettleTimer


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("cup_n_ball_ball") and body.is_live():
		candidate = body
		settle_timer.start()


func _on_body_exited(body: Node2D) -> void:
	if body == candidate:
		candidate = null
		settle_timer.stop()


func _on_settle_timer_timeout() -> void:
	# Ball's centre must be above the detector, i.e. it came in through the top.
	if is_instance_valid(candidate) and candidate.is_live() and candidate.global_position.y < global_position.y:
		ball_caught.emit(candidate)
