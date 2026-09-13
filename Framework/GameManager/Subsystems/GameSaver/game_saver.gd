class_name GameSaver extends Node


static func construct_file_path(file_name : String) -> String:
	return "user://" + GameSaver.sanitize_file_name(file_name) + ".save"


static func sanitize_file_name(file_name: String) -> String:
	var regex: RegEx = RegEx.new()
	var compile_error: int = regex.compile("[/\\\\:*?\"<>|]")
	
	if compile_error != Error.OK:
		printerr("%s: Cannot clean filename into valid path: %s" % ["GameSaver", file_name])
		return ""
	
	var cleaned: String = regex.sub(file_name, "", true) as String
	cleaned = cleaned.strip_edges() as String
	
	return cleaned


static func save_data_to_file(save_data : SaveData) -> void:
	var save_file_name : String = GameSaver.construct_file_path(save_data.get_file_name())
	var json_string : String = JSON.stringify(save_data.get_as_dict(), "\t")
	
	var file : FileAccess = FileAccess.open(save_file_name, FileAccess.WRITE)
	
	if file == null:
		printerr("GameSaver: could not access file: " % [save_file_name])
		return 
	
	file.store_string(json_string)
	file.close()

#
#static func get_save_data() -> SaveData:
	## checking if save data exists
	#if not FileAccess.file_exists(SAVE_FILE_NAME):
		#return null
	#
	## Open file
	#var file : FileAccess = FileAccess.open(SAVE_FILE_NAME, FileAccess.READ)
	#
	## Pull data from file & cloes file
	#var json_string = file.get_as_text()
	#file.close()
	#
	## parse JSON into whatever data type exists as a string currently
	## so if data looks like: "[1, 2, 3]" json.data becomes type Array
	## and if data looks like: "{"first": 1, "second": 2, "third": 3}" then json.data becomes type Dictionary
	#var json : JSON = JSON.new()
	#var error : Error = json.parse(json_string)
	#
	#if error != Error.OK:
		#print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		#return null
	#
	## checking that our data is our chosen type
	#if json.data is not Dictionary:
		#printerr("%s: JSON data received is not of type Dictionary") 
		#return null
	#
	## pass data to SaveData
	#return SaveData.from_dict(json.data as Dictionary)


static func get_save_data_as_dict(file_name : String) -> Dictionary:
	var save_file_name : String = GameSaver.construct_file_path(file_name)
	# checking if save data exists
	if not FileAccess.file_exists(save_file_name):
		return {}
	
	# Open file
	var file : FileAccess = FileAccess.open(save_file_name, FileAccess.READ)
	
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
		return {}
	
	# checking that our data is our chosen type
	if json.data is not Dictionary:
		printerr("%s: JSON data received is not of type Dictionary") 
		return {}
	
	# pass data to SaveData
	return json.data as Dictionary
