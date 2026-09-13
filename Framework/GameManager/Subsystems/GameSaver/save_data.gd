@abstract class_name SaveData


@abstract func get_as_dict() -> Dictionary[String, Variant]
@abstract func get_file_name() -> String

## [param data] is not cast as Dictionary[String, Variant] because of JSON string parsing
@warning_ignore("unused_parameter")
static func from_dict(data : Dictionary):
	return
