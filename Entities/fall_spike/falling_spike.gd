extends RigidBody2D
class_name FallingSpike





func _on_body_entered(body:Node2D):
	print("Collision detected with: ", body.name)
	print("Falling spike collided at position: ", global_position)
	queue_free()


func _on_hazard_area_entered(area: Area2D) -> void:
	print("Area detected with: ", area.name)
	print("Falling spike area at position: ", global_position)
	queue_free()
