extends Node2D

@onready var _lvlManager:LevelManager = $LevelManager
@onready var _cam:PhantomCamera2D = $PlayerPhantomCamera2D
var Nlevels:int


var _time: float = 0.0  




func _ready():
	get_tree().connect("node_removed", _on_node_removed)
	Nlevels = _lvlManager.NLevels
	
	
func _process(delta: float) -> void:
	_time += delta



func _on_node_removed(removed_node: Node):
	if removed_node == _cam.follow_target:
		_cam.follow_target = null

func set_camera_target(target:Node2D):
	_cam.follow_target = target

func Lose():
	print("Lose!")
	_lvlManager.RestartLevel()
	
func GoToNextLevel():
	_lvlManager.GoToNextLevel()
	if _lvlManager.entered_final_level():
		print("Posting score")
		SilentWolf.Scores.persist_score(global.player_name, _time)	

	
