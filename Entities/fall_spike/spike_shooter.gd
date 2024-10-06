extends Node2D
class_name SpikeShooter

var is_active := true
@onready var raycast = $DownRaycast
const FallingSpike = preload("falling_spike.tscn")


func _physics_process(delta):
	if is_active and raycast.is_colliding():

		var collider = raycast.get_collider()

		print("SpikeShooter raycast hit! ", collider)
		if collider is Player:
			print("Player hit")
			shoot_spike()
			disable_shooter()
			# disable spike shooter now that it has shot one
			

func shoot_spike():
	var falling_spike = FallingSpike.instantiate()
	falling_spike.global_position = global_position
	get_parent().add_child(falling_spike)
	print("Spike shot at position: ", global_position)

func disable_shooter():
	is_active = false
	set_physics_process(false)
	print("SpikeShooter disabled")
