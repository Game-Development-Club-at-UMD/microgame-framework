extends Node2D
## Creates the cup scene at the player's cursor when the game starts.
##
## Before the cup enters the tree, its whole rope (every segment and the ball) is
## swung around the point where it ties onto the cup so it hangs straight down,
## at rest, under the cursor. That way the physics start settled instead of the
## rope dropping from its editor layout and whipping around.
##
## Keep this node at the origin: cup.gd sets the cup's local position to the mouse.

## Forwarded from the ball once its explosion/confetti has finished.
signal round_finished(won: bool)

@export var cup_scene: PackedScene
## Path from the cup's root to its ball.
@export var ball_path: NodePath = ^"Balllll"
## Seconds on the ball's fuse. CupNBallMicrogame sets this from the difficulty.
@export var fuse_duration: float = 10.0

var cup: Node2D


func _ready() -> void:
	spawn_cup()


func spawn_cup() -> void:
	cup = cup_scene.instantiate()
	cup.position = get_global_mouse_position()
	_hang_rope(cup)
	var ball = cup.get_node(ball_path)
	# Must be set before the FuseTimer enters the tree and starts counting.
	ball.get_node("FuseTimer").duration = fuse_duration
	add_child(cup)
	ball.popped.connect(round_finished.emit)


# Rotates every rigid body in the cup (rope segments + ball) around the rope's tie
# point so the ball ends up directly below it. Joints are children of the segments,
# so they rotate along and get set up in the hanging layout when they enter the tree.
func _hang_rope(new_cup: Node2D) -> void:
	var anchor := _find_rope_anchor(new_cup)
	var ball := new_cup.get_node(ball_path) as Node2D
	var turn := Vector2.DOWN.angle() - (ball.position - anchor).angle()
	for body in new_cup.get_children():
		if body is RigidBody2D:
			body.position = anchor + (body.position - anchor).rotated(turn)
			body.rotation += turn


# The tie point is the PinJoint2D whose node_a is the cup itself.
func _find_rope_anchor(new_cup: Node2D) -> Vector2:
	for body in new_cup.get_children():
		if body is not RigidBody2D:
			continue
		for joint in body.get_children():
			if joint is PinJoint2D and joint.get_node_or_null(joint.node_a) == new_cup:
				return body.position + joint.position.rotated(body.rotation)
	return Vector2.ZERO
