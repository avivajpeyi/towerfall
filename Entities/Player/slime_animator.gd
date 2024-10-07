extends AnimatedSprite2D

var _old_state: Player.STATE
var _new_state: Player.STATE
var _dir:float



const WALL_LAND_ANIM = "wall_land"
const WALL_JUMP_ANIM = "wall_jump"
const WALL_SLIDE_ANIM = "wall_slide"
const FLOOR_LAND_ANIM = "floor_land"
const FLOOR_JUMP_ANIM = "floor_jump"
const FLOOR_SLIDE_ANIM = "floor_slide"
const DEATH_ANIM = "death"

var debug:bool = true
@onready var player:Player



func _ready() -> void:
	# Connect to the player's state_changed signal
	player = get_parent() as Player
	player.just_died.connect(_play_death_anim)
	player.state_changed.connect(_on_player_state_changed)
		
	# Initial frame is for airborne state
	play("wall_jump")
	frame = 4
	stop()
	
func _on_player_state_changed(old_state:Player.STATE, new_state:Player.STATE, direction:float):
	_old_state = old_state
	_new_state = new_state
	_dir = direction
	flip_h = true if _dir > 0 else false
	play_transition_animation() 

func play_transition_animation():
	match _new_state:
		Player.STATE.WALL_SLIDING:
			flip_h=!flip_h
			play(WALL_LAND_ANIM)
		Player.STATE.FLOOR_SLIDING:
			flip_h=!flip_h
			play(FLOOR_LAND_ANIM)
		Player.STATE.STATIONARY:
			play(DEATH_ANIM)
		Player.STATE.IN_AIR:
			match _old_state:
				Player.STATE.WALL_SLIDING:
					play(WALL_JUMP_ANIM)
				Player.STATE.FLOOR_SLIDING:
					play(FLOOR_JUMP_ANIM)
	print("Playing ", animation)

func _on_animation_finished():
	match animation:
		WALL_LAND_ANIM:
			flip_h=!flip_h
			play(WALL_SLIDE_ANIM)
		FLOOR_LAND_ANIM:
			flip_h=!flip_h
			play(FLOOR_SLIDE_ANIM)
	print("Playing ", animation)

	
func _play_death_anim():
	play(DEATH_ANIM)
	
	

# Debugging visuals
func _draw():
	if player.debug:
		var p = get_viewport().get_canvas_transform().basis_xform_inv(Vector2.ZERO)
		p.y -= 2
		draw_string(ThemeDB.fallback_font, p, animation, HORIZONTAL_ALIGNMENT_CENTER, -1, 10, Color.WHITE)
