extends Area2D
class_name Hazard




func _on_area_entered(area):
	print("Area entered hazard: ", area)
	var parent =  area.get_parent()
	if parent is Player:
		GameManager.Lose()
