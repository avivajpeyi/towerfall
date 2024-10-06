extends Area2D


@onready var my_sprite := $Sprite2D
@export var jump_force: float = 200

 

func _on_area_entered(area: Area2D) -> void:
	var parent =  area.get_parent()
	if parent is Player:
		var p = global_position
		p.x += 2
		parent._spring_jump(jump_force, p)
