extends Node2D
class_name LevelManager

signal level_changed(level_num:int)








var _level_idx = 0
var _level_names = _load_level_paths()
var _transition_settings:Dictionary = {
		"pattern_enter": "squares",
		"pattern_leave": "squares",
		"invert_on_leave": true,
	}
	


var NLevels:int = len(_level_names)


func entered_final_level()->bool:
	return get_current_level_num() == NLevels

func get_current_level_num():
	return _level_idx + 1
	
func RestartLevel():
	SceneManager.reload_scene(_transition_settings)

func GoToNextLevel():
	_level_idx+=1 
	SceneManager.change_scene(_level_names[_level_idx], _transition_settings)
	level_changed.emit(_level_idx)
	
func _load_level_paths()->PackedStringArray:
	var level_files = FileUtils.find_files_of_type("res://Levels/levels/", "scn")
	var sorted_files = []
	for i in range(len(level_files)):
		sorted_files.append("res://Levels/levels/level_%d.scn"%i)
	level_files= PackedStringArray(sorted_files)
	print(level_files)
	return sorted_files
