extends Node2D
class_name Shooter

@export var shoot_interval: float = 1.0
@export var projectile_speed: float = 200.0
@export var projectile_scene: PackedScene

@onready var timer: Timer = $ShootTimer
@onready var shoot_position: Marker2D = $ShootPosition

func _ready():
	if not projectile_scene:
		push_error("Projectile scene not set for Shooter")
		return
	
	timer.wait_time = shoot_interval
	timer.timeout.connect(_on_shoot_timer_timeout)
	timer.start()

func _on_shoot_timer_timeout():
	shoot()

func shoot():
	if projectile_scene:
		var projectile = projectile_scene.instantiate()
		AudioManager.shoot_sfx.play()
		
		if projectile is RigidBody2D:
			projectile.global_position = shoot_position.global_position
			projectile.linear_velocity = Vector2.RIGHT.rotated(global_rotation) * projectile_speed
			get_tree().current_scene.add_child(projectile)
		else:
			push_error("Projectile scene is not a RigidBody2D")

func set_shoot_interval(interval: float):
	shoot_interval = interval
	timer.wait_time = shoot_interval
