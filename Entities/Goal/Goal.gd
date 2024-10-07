extends Area2D
class_name Goal


func _on_area_entered(area):
	var parent =  area.get_parent()
	if parent is Player:
		AudioManager.play_lvl_complete_sfx()
		GameManager.GoToNextLevel()
