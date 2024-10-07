extends Node2D

@onready var _cam:PhantomCamera2D = $PlayerPhantomCamera2D

@export var magnitude: float = 2.0


var is_shaking: bool = false
var shake_time: float = 0.05
var shake_amt: Vector2 = Vector2.ZERO



var _time: float = 0.0  




func _ready():
	get_tree().connect("node_removed", _on_node_removed)
	
	
	
func _process(delta: float) -> void:
	_time += delta

	if is_shaking:
		shake_amt = Vector2(randf_range(-1,1), randf_range(-1,1)) * magnitude
		_cam.global_position += shake_amt
		
	
	
func CamShake():
	is_shaking = true
	await get_tree().create_timer(shake_time).timeout
	is_shaking = false  

func _on_node_removed(removed_node: Node):
	if removed_node == _cam.follow_target:
		_cam.follow_target = null

func set_camera_target(target:Node2D):
	_cam.follow_target = target
