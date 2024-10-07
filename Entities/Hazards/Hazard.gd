extends Area2D
class_name Hazard




func _on_area_entered(area):
	var parent =  area.get_parent()
	if parent is Player:
		print("Player killed by hazard")
		parent.Die()
