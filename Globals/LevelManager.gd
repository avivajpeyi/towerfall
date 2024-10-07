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
	print("Level manager loaded")
	for i in range(NLevels):
		_level_files.append("res://Levels/levels/Level_{0}.scn".format([i]))
	await get_tree().create_timer(0.2).timeout
	update_current_level_idx()
	print("In ", GetCurrentLevelName())
	
func on_final_level()->bool:
	return _level_idx == NLevels

func update_current_level_idx():
	var s = GetCurrentLevelNode()
	if s!= null:
		_level_idx = int(s.split("_")[-1])
	_level_idx = -1
		
	
	
func RestartLevel():
	SceneManager.reload_scene(_transition_settings)


func GetCurrentLevelNode():
	var nodes = get_tree().get_nodes_in_group("level")
	if nodes.size() > 0:
		return nodes[0]
	return null
		

func GetCurrentLevelName()->String:
	return "level_{0}".format([_level_idx])

func GetLevelPath(idx):
	return _level_files[idx]

func GoToNextLevel():
	if on_final_level():
		print("On final leve, cant go to another level!")
	else:
		_level_idx+=1 
		SceneManager.change_scene(GetLevelPath(_level_idx), _transition_settings)
		level_changed.emit(_level_idx)
		print("Moved to ", GetCurrentLevelName())
		
		
	
	
