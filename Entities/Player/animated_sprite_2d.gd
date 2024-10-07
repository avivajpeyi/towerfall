extends AnimatedSprite2D

enum STATE { STATIONARY, IN_AIR, WALL_SLIDING, FLOOR_SLIDING }
enum FACING { LEFT=-1, RIGHT=1}

var dir: FACING # To check which wall player is coming from for wall -> floor jump
var current_state: STATE


func _ready() -> void:
	# Connect to the player's state_changed signal
	var player = get_parent()
	player.connect("state_changed", Callable(self, "_on_player_state_changed"))
	
	connect("animation_finished", Callable(self, "_on_animation_finished"))
		
	# Initial frame is for airborne state
	play("wall_jump")
	frame = 4
	stop()

func play_animation():
	if current_state == STATE.WALL_SLIDING:
		if dir == FACING.LEFT:
			play("wall_land")
		elif dir == FACING.RIGHT:
			play("wall_land")
			flip_h = true
	elif current_state == STATE.FLOOR_SLIDING: # Transition to floor_slide on animation finish
		if dir == FACING.LEFT:
			play("floor_land")
		elif dir == FACING.RIGHT:
			play("floor_land")
			flip_h = true
	elif current_state == STATE.STATIONARY:
			play("death")
			

func _on_animation_finished():
	if current_state == STATE.FLOOR_SLIDING and animation == "floor_land":
		if dir == FACING.LEFT:
			play("floor_slide")
		if dir == FACING.RIGHT:
			play("floor_slide")
	elif current_state == STATE.WALL_SLIDING and animation == "wall_land":
		if dir == FACING.LEFT:
			play("wall_slide")
		elif dir == FACING.RIGHT:
			play("wall_slide")
			flip_h = true
	
