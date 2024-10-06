extends Camera2D

@onready var phantom_camera = %PlayerPhantomCamera2D
@export var magnitude: float = 2.0

var is_shaking: bool = false
var shake_time: float = 0.05
var shake_amt: Vector2 = Vector2.ZERO

func _shake():
	is_shaking = true
	await get_tree().create_timer(shake_time).timeout
	is_shaking = false  

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"): _shake()
	
	if !is_shaking: return
	
	shake_amt = Vector2(randf_range(-1,1), randf_range(-1,1)) * magnitude
	phantom_camera.global_position += shake_amt
