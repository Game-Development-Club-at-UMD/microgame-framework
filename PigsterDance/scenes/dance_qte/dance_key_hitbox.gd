class_name DanceKeyHitbox
extends Area2D

func _ready() -> void:
	area_entered.connect(_on_hit_box_area_entered)
	area_exited.connect(_on_hit_box_area_exited)
	

func _on_hit_box_area_entered(area: Area2D) -> void:
	var key: QteKey = area.get_parent()
	if key != null:
		key.is_key_in_box = true


func _on_hit_box_area_exited(area: Area2D) -> void:
	
	var key: QteKey = area.get_parent()
	if key == null:
		return
	key.is_key_in_box = false
	if key.is_state_pending():
		key.fail_state()
