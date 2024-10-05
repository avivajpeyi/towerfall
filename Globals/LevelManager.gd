extends Node2D
class_name LevelManager

var _level_idx = 0
var _level_names = _load_level_paths()
var _transition_settings:Dictionary = {
		"pattern_enter": "squares",
		"pattern_leave": "squares",
		"invert_on_leave": true,
	}


	
func RestartLevel():
	var current_scene = get_tree().current_scene
	SceneManager.reload_scene(_transition_settings)

func GoToNextLevel():
	_level_idx+=1 
	SceneManager.change_scene(_level_names[_level_idx], _transition_settings)

func _load_level_paths()->PackedStringArray:
	var level_files = FileUtils.find_files_of_type("res://Levels/levels/", "scn")
	level_files = level_files.duplicate() as Array
	level_files.sort_custom(_compare_level_names)
	return PackedStringArray(level_files)

func _compare_level_names(a: String, b: String) -> int:
	var num_a = int(a.get_basename().split("_")[-1])  # Extracts the number after the last underscore
	var num_b = int(b.get_basename().split("_")[-1])  # Extracts the number after the last underscore
	return num_a - num_b
