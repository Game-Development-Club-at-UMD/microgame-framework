extends Area2D

signal win

func _process(_delta: float) -> void:
	pass
		
func _on_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		print("You won!")
		win.emit()
		GameManager.win()
