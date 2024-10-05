extends Node
class_name Door


var _num_required_keys:int = 0
var _num_keys_collected: int = 0  # Keep track of the collected keys


@onready var open_sprite: Sprite2D = $OpenSprite2D
@onready var locked_sprite: Sprite2D = $LockedSprite2D
@onready var collider: CollisionShape2D = $CollisionShape2D
var _is_locked: bool = true


func _ready():
	for key in get_tree().get_nodes_in_group("keys"):  # Ensure keys are in a group called "keys"
		key.connect("key_collected", _on_key_collected)
		_num_required_keys +=1 
	_lock_door(true)


func _on_key_collected():
	_num_keys_collected += 1
	print("Collected a key! Total keys:", _num_keys_collected)

	if _num_keys_collected >= _num_required_keys:
		_lock_door(false) 


func _lock_door(lock:bool):
	_is_locked = lock
	if lock:
		print("Lock door!")
		collider.disabled = false
		open_sprite.visible = false
		locked_sprite.visible = true
	else:
		print("unlock door!")
		collider.disabled = true
		open_sprite.visible = true
		locked_sprite.visible = false
