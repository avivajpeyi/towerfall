extends CharacterBody2D

class_name Player

@onready var sprite := $Sprite2D
@onready var physics_collider := $CollisionShape2D
@onready var interaction_area := $Area2D
@onready var left_raycast := $LeftRayCast2D  # Reference to the left RayCast2D
@onready var right_raycast := $RightRayCast2D  # Reference to the right RayCast2D



var dead:bool = false

enum WallSide { NONE=0, LEFT=-1, RIGHT=1 }
var wall_side: WallSide = WallSide.NONE
var face_direction:int = -1
var _just_landed_on_wall = false

# Movement variables

var debug = false
var _in_spring_jump:bool = false
var grav_scale: float = 2.0
var terminal_velocity: float = 500.0
@export var wall_sliding_speed: float = 100.0
var friction: float = 200.0
var _fric_thresh: float = 0.001

const leap_magnitude: float = 150.0
const leap_angle: float = 15.0
const DEG_TO_RAD: float = PI / 180.0
var _leap_vec: Vector2 = Vector2(
	abs(leap_magnitude * cos(leap_angle * DEG_TO_RAD)),
	-abs(leap_magnitude * sin(leap_angle * DEG_TO_RAD))
)
const _jump_vec: Vector2 = Vector2(0, -75)

var wall_landing_timer:Timer

# Fall variables
var _last_ypos: float = 0.0
var _fall_thresh: float = 10.0

# Player states
enum STATE { STATIONARY, IN_AIR, WALL_SLIDING, FLOOR_SLIDING }
var state: STATE = STATE.IN_AIR

func _ready():
	_last_ypos = position.y
	GameManager.set_camera_target(self)
	wall_landing_timer = Timer.new()
	wall_landing_timer.wait_time = 0.05  # Set the time duration (adjust as needed)
	wall_landing_timer.one_shot = true
	add_child(wall_landing_timer)
	wall_landing_timer.timeout.connect(_on_wall_landing_timer_timeout)

func is_stationary() -> bool:
	return abs(velocity.x) < _fric_thresh

func _process(_delta):
	queue_redraw()

func _physics_process(delta):
	if !dead:
		_fric_thresh = friction * delta
		_check_wall_side()
		_update_state()
		apply_gravity()
		handle_movement()
		move_and_slide()
	else:
		velocity=Vector2.ZERO

func _slide_up():
	pass

# Apply gravity and velocity constraints
func apply_gravity():
	if state == STATE.IN_AIR:
		velocity.y = min(velocity.y + grav_scale, terminal_velocity)

# Handle player movement and states
func handle_movement():
	match state:
		STATE.FLOOR_SLIDING:
			if !is_stationary():
				velocity.x -= sign(velocity.x) * _fric_thresh
		STATE.WALL_SLIDING:
			if _just_landed_on_wall:
				velocity.y = -0.25*wall_sliding_speed
			else:
				velocity.y = lerp(velocity.y, wall_sliding_speed, 0.1)
			_last_ypos = position.y  # Update y-position for fall calculation
		STATE.STATIONARY:
			var fall_distance = abs(position.y - _last_ypos)
			if fall_distance > _fall_thresh:
				Die()
			elif wall_side==WallSide.NONE:
				Die()


	if Input.is_action_just_pressed("jump") and !dead:
		_jump()
		

func _input(event):
	if event.is_action_pressed("debug_mode"):
		debug = !debug
	

# Jump functionality
func _jump():
	var jumped = false
	match state:
		STATE.WALL_SLIDING, STATE.FLOOR_SLIDING:
			velocity = _leap_vec
			jumped = true
		STATE.STATIONARY:
			velocity = _jump_vec
			if global.end_game_mode:
				velocity=_leap_vec
			jumped = true

	if jumped:
		GameManager.CamShake()
		AudioManager.play_jump_sfx()
	

func _update_state():
	if _is_on_wall():
		if state!=STATE.WALL_SLIDING:
			_just_landed_on_wall = false
			#wall_landing_timer.start()
		state = STATE.WALL_SLIDING
	elif is_on_floor():
		if !is_stationary():
			state = STATE.FLOOR_SLIDING
		else:
			state = STATE.STATIONARY
	elif !_is_on_wall() and !is_on_floor():
		state = STATE.IN_AIR

func Die():
	if !dead and !global.end_game_mode:
		AudioManager.play_die_sfx()
		GameManager.Lose()
		dead = true
		velocity = Vector2.ZERO  # Stop movement by setting velocity to zero
		set_physics_process(false)  # Disable physics processing
		set_process(false)  # Optionally disable input or other processing
		sprite.modulate = Color(1, 1, 1, 0.5)  # Optionally fade out the player sprite
		# Play death animation, sound, or any other effects
		print("Player has died")

# Debugging visuals
func _draw():
	if debug:
		var screen_pos = get_viewport().get_canvas_transform().basis_xform_inv(Vector2.ZERO)
		var side = "L" if face_direction < 0 else "R"
		var t = _get_state_str() + "(" + side + ")"
		draw_string(ThemeDB.fallback_font, screen_pos, t, HORIZONTAL_ALIGNMENT_CENTER, -1, 10, Color.WHITE)
		draw_line(Vector2.ZERO, _leap_vec, Color.RED, 2)
		draw_line(Vector2.ZERO, Vector2(0, _fall_thresh), Color.RED, 2)
		draw_line(Vector2.ZERO, _jump_vec, Color.GREEN, 2)

func _get_state_str() -> String:
	match state:
		STATE.STATIONARY:
			return "Stationary"
		STATE.FLOOR_SLIDING:
			return "Floor-Sliding"
		STATE.IN_AIR:
			return "Airborne"
		STATE.WALL_SLIDING:
			return "Wall-Sliding"
		_:
			return "Unknown"



func _spring_jump(force, start_point):
	left_raycast.enabled = false
	right_raycast.enabled = false
	_in_spring_jump= true
	velocity.y = -force
	velocity.x = 0
	position = start_point
	await get_tree().create_timer(0.75).timeout
	_in_spring_jump=false
	left_raycast.enabled = true
	right_raycast.enabled = true

func _on_wall_landing_timer_timeout():
	_just_landed_on_wall = false


func _check_wall_side():
	if left_raycast.is_colliding():
		#print("Raycast L on", left_raycast.get_collider())
		wall_side = WallSide.LEFT
		face_direction = -1
	elif right_raycast.is_colliding():
		#print("Raycast R on", right_raycast.get_collider())
		wall_side = WallSide.RIGHT
		face_direction = 1
	else:
		wall_side = WallSide.NONE
	_leap_vec.x = abs(_leap_vec.x) * -1 * sign(face_direction)

func _is_on_wall():
	if _in_spring_jump:
		return false
	elif  wall_side != WallSide.NONE:
		return true
	elif is_on_wall():
		return true
	return false
