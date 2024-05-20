extends Node


### variables and simple functions ###
var game_info = {
	default_save_file = 0,
	default_save_file_location = 0,
	
	save_file = [{},{},{},{},{},{},{},{},{},{}],
	save_file_location = ["user://data.dat","","","","","","","","",""],
	
	encryption_key = "(|QSave_default_key|)",
}


func get_info(info : String = "time"):
	if info == "time":
		var r_info = Time.get_time_string_from_system()
		return "[" + str(r_info) + "]: "


### save and load functions ###
func save_file(file : Dictionary = game_info["default_save_file"][game_info["default_save_file"]], location : String = game_info["save_file"][game_info["default_save_file_location"]], encrypted : bool = false, encryption_key : String = game_info["encryption_key"]):
	var s_file : FileAccess
	
	if location:
		if encrypted:
			s_file = FileAccess.open_encrypted_with_pass(location, FileAccess.WRITE, encryption_key)
			s_file.store_var(file)
			s_file.close()
		else:
			s_file = FileAccess.open(location, FileAccess.WRITE)
			s_file.store_var(file)
			s_file.close()
	else:
		return [false, get_info("time") + "Save File location wasn't found", 1]
	
	if s_file:
		return [true, get_info("time") + "Save File was saved", 0]
	else:
		return [false, get_info("time") + "Save File couldn't be loaded", 2]

func load_file(location : String = game_info["save_file_location"][game_info["default_save_file_location"]], encrypted : bool = false, encryption_key : String = game_info["encryption_key"]):
	var s_file : FileAccess
	var r_file : Dictionary
	
	if location:
		if FileAccess.file_exists(location):
			if encrypted:
				s_file = FileAccess.open_encrypted_with_pass(location, FileAccess.READ, encryption_key)
				r_file = s_file.get_var()
				s_file.close()
			else:
				s_file = FileAccess.open(location, FileAccess.READ)
				r_file = s_file.get_var()
				s_file.close()
		else:
			return [false, get_info("time") + "Save File wasn't found", 6]
	else:
		return [false, get_info("time") + "Save File location wasn't found", 4]
	
	if s_file:
		return [true, r_file, 3]
	else:
		return [false, get_info("time") + "Save File couldn't be loaded", 5]

func create_dir(name : String = "New Folder", location : String = "user://"):
	if not DirAccess.dir_exists_absolute(location + name):
		DirAccess.make_dir_absolute(location + name)
		return [true, location + name, 7]
	else:
		return [false, get_info("time") + "Folder " + name + " already exists in " + location, 8]


### save functions ###
func s_save(file : Dictionary = game_info["default_save_file"][game_info["default_save_file"]], location : String = game_info["save_file_location"][game_info["default_save_file_location"]]):
	var save = save_file(file, location, true, game_info["encryption_key"])
	
	var worked = save[0]
	var s_file = save[1]
	var error_code = save[2]
	
	if !worked:
		return get_info("time") + "SafeSave wasn't able to save the file - " + str(s_file) + " - " + str(error_code)
	else:
		return get_info("time") + "SafeSave file was saved"
	

func s_load(location : String = game_info["save_file_location"][game_info["default_save_file_location"]]):
	var load = load_file(location, true, game_info["encryption_key"])
	
	var worked = load[0]
	var l_file = load[1]
	var error_code = load[2]
	
	if !worked:
		if error_code == 3:
			return l_file
		elif error_code == 6:
			var save = s_save(game_info["save_file"][game_info["default_save_file"]], location)
			return s_load(location)
		elif error_code == 4:
			return get_info("time") + "SafeLoad wasn't able to recognize the location, the request was aborted - " + str(l_file) + " - " + str(error_code)
		elif error_code == 5:
			return get_info("time") + "SaveLoad wasn't able to load the file, the request was aborted - " + str(l_file) + " - " + str(error_code)
	else:
		return l_file
	

func s_resetsave(location : String = game_info["save_file_location"][game_info["default_save_file_location"]]):
	print(s_save(game_info["default_save_file"][game_info["default_save_file"]], location))
