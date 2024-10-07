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
	
	SceneManager.scene_loaded.connect(_update_level_data)


func _update_level_data():
	var s:String = global.current_level_name
	if "_" in s:
		_level_idx = int(s.split("_")[-1])
		
	if in_final_level():
		global._set_game_to_end_state()


func in_final_level()->bool:
	return (_level_idx + 1) >= NLevels

	
func RestartLevel():
	SceneManager.reload_scene(_transition_settings)

func GoToNextLevel():
	if !in_final_level():
		global.current_level_name = "Level_%d"%(_level_idx+1)
		print("Moving from %d to %d (new lvl: %s)"%[_level_idx, _level_idx+1, global.current_level_name])
		_level_idx+=1 
		SceneManager.change_scene(_level_files[_level_idx], _transition_settings)
		await SceneManager.scene_unloaded
		level_changed.emit(_level_idx)
	if in_final_level():
		print("END GAME")
		global._set_game_to_end_state()


func GetCurrentLevelName()->String:
	return "level_{0}".format([_level_idx])

func GetLevelPath(idx):
	return _level_files[idx]
