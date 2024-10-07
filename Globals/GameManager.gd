extends Node2D

@onready var _lvlManager = $LevelManager
@onready var _cam:PhantomCamera2D = $PlayerPhantomCamera2D
var Nlevels:int


var _time: float = 0.0  


var shake_mag:float = 2.0
var is_shaking: bool = false
var shake_time: float = 0.05
var shake_amt: Vector2 = Vector2.ZERO


signal level_changed(level_idx:int)

func _ready():
	get_tree().connect("node_removed", _on_node_removed)
	Nlevels = _lvlManager.NLevels
	
	
func _process(delta: float) -> void:
	if !global.end_game_mode:
		_time += delta
	
	if is_shaking: 
		shake_amt = Vector2(randf_range(-1,1), randf_range(-1,1)) * shake_mag
		_cam.global_position += shake_amt



func _input(event):
	if global.debug_mode and event.is_action_pressed("skip_level"):
		GoToNextLevel()


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


	


func CamShake():
	is_shaking = true
	await get_tree().create_timer(shake_time).timeout
	is_shaking = false  

	
