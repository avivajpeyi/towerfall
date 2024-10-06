extends Node2D
class_name BreakableBlock

var break_time: float = 0.8
var is_broken: bool = false
@onready var shaker := $Sprite2D/ShakerComponent2D as ShakerComponent2D


func _break_block():
	queue_free()  



func _on_area_2d_area_entered(area):
	print(area.name, " entered block ", self)
	var parent =  area.get_parent()
	if parent is Player:
		print(self, " blck ging to be brken")
		shaker.play_shake()
		await get_tree().create_timer(break_time).timeout
		_break_block() # Replace with function body.
