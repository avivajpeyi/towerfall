extends CanvasLayer
class_name GameUi

@onready var player_name_label := $PlayerName
@onready var lvl_instruction_label  := $LevelInstruction
@onready var time_label := $LevelInfo/Time
@onready var lvl_num_label := $LevelInfo/LevelNumber
@onready var debug_label := $LevelInfo/DebugTxt

var debug:bool = false


var levels_instructions = {
	-1: "Unregistered",
	0: "Click to make %s jump",
	1: "Help %s wallslide its way down",
	2: "Dont let %s slow down too much",
	3: "",
	4: "%s doesnt like spikes",
	5: "These blocks break",
	6: "wheee springs!",
	7: "",
	8: "Keys unlock doors!",
	9: "Tip: %s can wall-jump pretty fast!",
	10: "",
	11: "",
	12: "",
	13: "",
	14: "",
	15: "Yay! %s made it out",
}



func _ready():
	_set_player_name()
	await get_tree().create_timer(0.1).timeout
	GameManager._lvlManager.level_changed.connect(_on_level_change)
	_on_level_change(0)

func _process(_delta: float) -> void:
	_update_time()
	
func _input(event):
	if event.is_action_pressed("debug_mode"):
		debug=!debug
		if debug:
			debug_label.text = "DEBUG: %s"%global.current_level_name
			player_name_label.text = ""
		else:
			debug_label.text = ""
			_set_player_name()


func _set_player_name():
	player_name_label.text = "Help %s escape!"%global.player_name

func _on_level_change(level_idx):
	set_level_data(level_idx+1, levels_instructions[level_idx])


func set_level_data( current_level_num:int, instructions:String):
	if instructions.find("%") != -1:
		instructions= instructions % global.player_name  # Apply formatting with player's name
	else:
		instructions= instructions  # Return the string as is
	lvl_instruction_label.text = instructions
	lvl_num_label.text = "%d/%d"%[current_level_num, GameManager.Nlevels-1]
	if global.end_game_mode:
		lvl_num_label.text = ""

func _update_time() -> void:
	time_label.text = _gametime_to_str()

func _gametime_to_str()->String:
	var minutes = int(GameManager._time) / 60
	var seconds = int(GameManager._time) % 60
	return "{0}:{1}".format({
		0:"%02d"%minutes,
		1:"%02d"%seconds,
		})


func _on_button_pressed():
	GameManager.Lose()
