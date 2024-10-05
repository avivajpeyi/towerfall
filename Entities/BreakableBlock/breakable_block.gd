extends Node2D
class_name BreakableBlock

@export var break_time: float = 2.0
var is_broken: bool = false

func _break_block():
	queue_free()  



func _on_area_2d_area_entered(area):
	print(area.name, " entered block ", self)
	var parent =  area.get_parent()
	if parent is Player:
		print(self, " blck ging to be brken")
		await get_tree().create_timer(break_time).timeout
		_break_block() # Replace with function body.
