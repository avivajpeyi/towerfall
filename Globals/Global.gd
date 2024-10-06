extends Node2D


var OST = load("res://Audio/OST.mp3")
var audio
var player_name:String


func _ready():
	_connect_to_leaderboard()
	player_name = _generate_player_name()
	await get_tree().create_timer(0.1).timeout
	_add_gamemusic_loop()
	


func _add_gamemusic_loop():
	audio = AudioStreamPlayer.new()
	add_child(audio)
	audio.stream = OST
	audio.play()
	audio.finished.connect(audio.play)
	

func _input(event):
	if event.is_action_pressed("ui_fullscreen"):
		var win_full = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE if win_full else DisplayServer.MOUSE_MODE_HIDDEN)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED if win_full else DisplayServer.WINDOW_MODE_FULLSCREEN)



func _connect_to_leaderboard():
	SilentWolf.configure({
		"api_key": "xRcZ5BFPDK5AyEzuDjVmXaF8u4u1iA7UPNNX8KP6",
		"game_id": "towerfall",
		"game_version": "1.0.2",
		"log_level": 1
	})

	SilentWolf.configure_scores({
	"open_scene_on_close": "res://scenes/MainPage.tscn"
	})
	
	

func _generate_player_name() -> String:
	var prefixes = ["Fli", "Twi", "Pip", "Bub", "Nim", "Doo", "Zee", "Mimi", "Lolo", "Tee"]
	var suffixes = ["pie", "bin", "po", "dee", "boo", "zi", "bi", "lu", "lo", "ni"]

	var prefix = prefixes[randi() % prefixes.size()]
	var suffix = suffixes[randi() % suffixes.size()]
	var number = randi() % 100  # Random number from 0 to 99
	return "%s%s [%d]" % [prefix, suffix, number]
