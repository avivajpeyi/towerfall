extends Area2D
class_name Goal

func _on_area_entered(area):
	print("Area entered goal: ", area)
	var parent =  area.get_parent()
	if parent is Player:
		GameManager.GoToNextLevel()
