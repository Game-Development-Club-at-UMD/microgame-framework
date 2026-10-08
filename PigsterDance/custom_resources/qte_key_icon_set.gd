class_name QteKeyIconSet
extends Resource

@export var icons: Array[QteKeyIcon] = []

var icon_map: Dictionary = {}


func get_icon(keycode: Key) -> QteKeyIcon:
	if icon_map.is_empty():
		build_icon_map()
	return icon_map.get(keycode)


func build_icon_map() -> void:
	icon_map.clear()
	for icon in icons:
		if icon == null:
			push_error("QteKeyIconSet: empty icon")
			continue
		if icon_map.has(icon.keycode):
			push_warning("QteKeyIconSet: duplicate keycode %s" % OS.get_keycode_string(icon.keycode))
		icon_map[icon.keycode] = icon
