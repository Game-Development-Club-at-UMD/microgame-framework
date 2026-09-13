class_name GameSaver extends Node

const SAVE_FILE_NAME : String = ""


static func save_data_to_file(save_data : SaveData) -> void:
	var json_string : String = JSON.stringify(save_data.get_as_dict(), "\t")
	
	var file : FileAccess = FileAccess.open(SAVE_FILE_NAME, FileAccess.WRITE)
	
	if file == null:
		printerr("GameSaver: could not access file: " % [SAVE_FILE_NAME])
		return 
	
	file.store_string(json_string)
	file.close()


static func get_save_data() -> SaveData:
	# checking if save data exists
	if not FileAccess.file_exists(SAVE_FILE_NAME):
		return null
	
	# Open file
	var file : FileAccess = FileAccess.open(SAVE_FILE_NAME, FileAccess.READ)
	
	# Pull data from file & cloes file
	var json_string = file.get_as_text()
	file.close()
	
	# parse JSON into whatever data type exists as a string currently
	# so if data looks like: "[1, 2, 3]" json.data becomes type Array
	# and if data looks like: "{"first": 1, "second": 2, "third": 3}" then json.data becomes type Dictionary
	var json : JSON = JSON.new()
	var error : Error = json.parse(json_string)
	
	if error != Error.OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return null
	
	# checking that our data is our chosen type
	if json.data is not Dictionary:
		printerr("%s: JSON data received is not of type Dictionary") 
		return null
	
	# pass data to SaveData
	return SaveData.from_dict(json.data as Dictionary)
