extends Node
class_name Door


var _num_required_keys:int = 0
var _num_keys_collected: int = 0  # Keep track of the collected keys


@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var static_body: StaticBody2D = $StaticBody2D
@onready var shaker: ShakerComponent2D = $AnimatedSprite2D/ShakerComponent2D
var _is_locked: bool = true


func _ready():
	for key in get_tree().get_nodes_in_group("door_keys"):  # Ensure keys are in a group called "door_keys"
		key.connect("key_collected", _on_key_collected)
		_num_required_keys +=1 
	_lock_door(true)


func _on_key_collected():
	_num_keys_collected += 1
	if _num_keys_collected >= _num_required_keys:
		_lock_door(false) 


func _lock_door(lock:bool):
	_is_locked = lock
	if lock:
		animated_sprite.play("locked")
		static_body.set_collision_layer_value(1, true)  # Enable collision on layer 1
		static_body.set_collision_mask_value(1, true)   # Enable collision mask on layer 1
	else:
		animated_sprite.play("unlocked")
		static_body.set_collision_layer_value(1, false)  # Disable collision on layer 1
		static_body.set_collision_mask_value(1, false)   # Disable collision mask on layer 1
		shaker.play_shake()
