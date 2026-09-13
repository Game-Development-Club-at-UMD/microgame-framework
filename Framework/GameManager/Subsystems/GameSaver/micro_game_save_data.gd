class_name MicroGameSaveData extends SaveData


const FILE_NAME : String = "micro_game"

var wins : int = 0
var lives : int = 0
var current_difficulty : float = 0


func get_file_name() -> String:
	return FILE_NAME


func get_as_dict() -> Dictionary[String, Variant]:
	return {
		"wins": wins,
		"lives": lives,
		"current_difficulty": current_difficulty,
	}


static func from_dict(data : Dictionary) -> MicroGameSaveData:
	var save_data : MicroGameSaveData = MicroGameSaveData.new()
	
	save_data.wins = data.get("wins", 0)
	save_data.lives = data.get("lives", 0)
	save_data.current_difficulty = data.get("current_difficulty", 0)
	
	return save_data
