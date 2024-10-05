extends Node
class_name key

signal key_collected

func _on_area_entered(area):
	print("Area ", area, " entered key")
	if area.parent is Player:
		print("Player picks up key -- maybe becomoes inventry?")
		emit_signal("key_collected")  # Emit the signal to notify key collection
		#queue_free()  # Remove the key after it's collected
