extends RigidBody2D
class_name FallingSpike



func _on_body_entered(body:Node2D):
	queue_free()


func _on_hazard_area_entered(area: Area2D) -> void:
	queue_free()
