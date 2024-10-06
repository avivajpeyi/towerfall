extends Node2D
class_name DoorKey

signal key_collected

func _ready():
	add_to_group("door_keys")
	
func _on_area_entered(area: Area2D) -> void:
	var parent =  area.get_parent()
	if parent is Player:
		print(self, "Key is collected.")
		emit_signal("key_collected")  # Emit the signal to notify key collection
		queue_free()  # Remove the key after it's collected
