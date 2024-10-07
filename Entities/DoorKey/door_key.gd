extends Node2D
class_name DoorKey

signal key_collected

func _ready():
	add_to_group("door_keys")
	
func _on_area_entered(area: Area2D) -> void:
	var parent =  area.get_parent()
	if parent is Player:
		print(self, "Key is collected.")
		key_collected.emit()
		AudioManager.play_key_sfx()
		queue_free()  # Remove the key after it's collected
