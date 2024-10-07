extends Node2D

signal level_changed(level_num:int)


var _level_files = []
var _level_idx = 0
var _transition_settings:Dictionary = {
		"pattern_enter": "squares",
		"pattern_leave": "squares",
		"invert_on_leave": true,
		"color": Color.WHITE
	}
	
	
	
	


var NLevels:int = 15

func _ready():
	for i in range(NLevels):
		_level_files.append("res://Levels/levels/Level_{0}.scn".format([i]))
	


func entered_final_level()->bool:
	return get_current_level_num() == NLevels

func get_current_level_num():
	return _level_idx + 1
	
func RestartLevel():
	SceneManager.reload_scene(_transition_settings)

func GoToNextLevel():
	_level_idx+=1 
	SceneManager.change_scene(_level_files[_level_idx], _transition_settings)
	level_changed.emit(_level_idx)
	
