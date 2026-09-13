class_name SaveData

var wins : int = 0
var lives : int = 0
var current_difficulty : float = 0


func get_as_dict() -> Dictionary[String, Variant]:
	return {
		"wins": wins,
		"lives": lives,
		"current_difficulty": current_difficulty,
	}


## [param data] is not cast as Dictionary[String, Variant] because of JSON string parsing
static func from_dict(data : Dictionary) -> SaveData:
	var save_data = SaveData.new()
	
	 #if the data does not have any of these arguments, the values get set to the default 
	# param (0) passed into the get func, so this is safe!
	save_data.wins = data.get("wins", 0)
	save_data.lives = data.get("lives", 0)
	save_data.current_difficulty = data.get("current_difficulty", 0)
	
	return save_data
