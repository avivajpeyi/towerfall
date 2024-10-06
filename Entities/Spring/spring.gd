extends Area2D


@onready var my_sprite := $Sprite2D
@export var jump_force: float = 500

 

func _on_area_entered(area: Area2D) -> void:
	AudioManager.spring_sfx.play()
	var parent =  area.get_parent()
	if parent is Player:
		parent.velocity.y = -jump_force
