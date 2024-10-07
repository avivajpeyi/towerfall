extends Node2D

signal level_changed(level_idx:int)


var _level_files = []
var _level_idx = 0
var _transition_settings:Dictionary = {
		"pattern_enter": "squares",
		"pattern_leave": "squares",
		"invert_on_leave": true,
		"color": Color.WHITE
	}

var NLevels:int = 16

func _ready():
	for i in range(NLevels):
		_level_files.append("res://Levels/levels/Level_{0}.scn".format([i]))
	await get_tree().create_timer(0.2).timeout
	print(global.current_level_name)
	update_current_level_idx()
	level_changed.emit(_level_idx)
	print("In ", GetCurrentLevelName())


func update_current_level_idx():
	var s:String = global.current_level_name
	if "_" in s:
		_level_idx = int(s.split("_")[-1])
	else:
		_level_idx = -1

func in_final_level()->bool:
	return (_level_idx + 1) >= NLevels

	
func RestartLevel():
	SceneManager.reload_scene(_transition_settings)

func GoToNextLevel():
	print("Moving from %d to %d"%[_level_idx, _level_idx+1])
	_level_idx+=1 
	SceneManager.change_scene(_level_files[_level_idx], _transition_settings)
	await get_tree().create_timer(0.2).timeout
	level_changed.emit(_level_idx)
	if in_final_level():
		global._set_game_to_end_state()


func GetCurrentLevelName()->String:
	return "level_{0}".format([_level_idx])

func GetLevelPath(idx):
	return _level_files[idx]
