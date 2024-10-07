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
	15: "",
}


func get_current_lvl_num()->int:
	return GameManager._lvlManager._level_idx + 1


func _ready():
	_set_player_name()
	GameManager.level_changed.connect(_on_level_change)
	

func _process(_delta: float) -> void:
	if !global.end_game_mode:
		time_label.text = _gametime_to_str()
	
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

func _on_level_change(lvl_idx):
	var lvl_nm = lvl_idx + 1 
	set_level_data(lvl_nm, levels_instructions[lvl_nm-1])

func set_endgame_text():
	lvl_num_label.text = ""
	player_name_label.text = ""
	lvl_instruction_label.text = "Yay! %s made it out"%global.player_name
	


func set_level_data( current_level_num:int, instructions:String):
	print("Setting UI for lvl %d"%current_level_num)
	if instructions.find("%") != -1:
		instructions= instructions % global.player_name  # Apply formatting with player's name
	else:
		instructions= instructions  # Return the string as is
	lvl_instruction_label.text = instructions
	lvl_num_label.text = "%d/%d"%[current_level_num, GameManager.Nlevels-1]
	
	
	if global.end_game_mode or current_level_num>= GameManager.Nlevels:
		set_endgame_text()
		
	if debug:
		debug_label.text = "DEBUG: %s"%global.current_level_name


func _gametime_to_str()->String:
	var minutes = int(GameManager._time) / 60
	var seconds = int(GameManager._time) % 60
	return "{0}:{1}".format({
		0:"%02d"%minutes,
		1:"%02d"%seconds,
		})


func _on_button_pressed():
	GameManager.Lose()
