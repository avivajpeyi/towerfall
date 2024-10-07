extends Node2D


var OST = load("res://Audio/fall.mp3")
var audio
var player_name:String
var end_game_mode=false
var current_level_name:String
var debug_mode:bool = false


func _ready():
	SceneManager.scene_loaded.connect(_on_scene_loaded)
	player_name = _generate_player_name()
	await SceneManager.scene_loaded
	_add_gamemusic_loop()
	
	
func _on_scene_loaded():
	var child = get_tree().get_first_node_in_group('level')
	if child != null:
		current_level_name = child.name

	
func _input(event):
	if event.is_action_pressed("debug_mode"):
		debug_mode = !debug_mode
		print("Debug set to ", debug_mode)
		if debug_mode:
			DebugMenu.style = DebugMenu.Style.MAX
			DebugMenu.visible = true
		else:
			DebugMenu.style = DebugMenu.Style.HIDDEN
			DebugMenu.visible = false
	if event.is_action_pressed("ui_fullscreen"):
		var win_full = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE if win_full else DisplayServer.MOUSE_MODE_HIDDEN)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED if win_full else DisplayServer.WINDOW_MODE_FULLSCREEN)

	


func _add_gamemusic_loop():
	audio = AudioStreamPlayer.new()
	add_child(audio)
	audio.stream = OST
	audio.volume_db = -18
	audio.play()
	audio.finished.connect(audio.play)
	


func _set_game_to_end_state():
	end_game_mode = true


func _generate_player_name() -> String:
	var prefixes = ["Fli", "Twi", "Pip", "Bub", "Nim", "Doo", "Zee", "Mimi", "Lolo", "Tee"]
	var suffixes = ["pie", "bin", "po", "dee", "boo", "zi", "bi", "lu", "lo", "ni"]

	var prefix = prefixes[randi() % prefixes.size()]
	var suffix = suffixes[randi() % suffixes.size()]
	var number = randi() % 100  # Random number from 0 to 99
	return "%s%s" % [prefix, suffix]
