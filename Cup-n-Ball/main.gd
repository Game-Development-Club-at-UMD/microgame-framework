class_name CupNBallMicrogame extends MicroGame
## Cup-n-Ball: catch the fused ball in the cup before it blows up.
## Win = the cup zaps the ball into confetti. Lose = the fuse runs out and it explodes.

## Fuse length in seconds at difficulty 0.0 (easiest)...
@export var easiest_fuse_time: float = 10.0
## ...and at difficulty 1.0 (hardest).
@export var hardest_fuse_time: float = 5.0


# GameManager sets `difficulty` before this scene enters the tree, and CupSpawner
# spawns the cup in its own _ready (which runs before ours), so hand it over here.
func _enter_tree() -> void:
	$CupSpawner.fuse_duration = lerpf(easiest_fuse_time, hardest_fuse_time, difficulty)


func _on_cup_spawner_round_finished(won: bool) -> void:
	if won:
		GameManager.win()
	else:
		GameManager.lose()
