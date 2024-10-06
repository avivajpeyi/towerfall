extends CanvasLayer
class_name GameUi

@onready var player_name_label := $PlayerName
@onready var lvl_instruction_label  := $LevelInstruction
@onready var time_label := $LevelInfo/Time
@onready var lvl_num_label := $LevelInfo/LevelNumber

var levels_instructions = {
	0: "",
	1: "",
	2: "",
	3: "",
	4: "",
	5: "",
	6: "",
	7: "",
	8: "",
	9: "",
	10: "",
	11: "",
	12: "",
	13: "",
	14: "",
	15: "",
	16: "",
	17: "",
	18: "",
	19: "",
	20: "",
	21: "",
	22: ""
}



func _ready():
	_set_player_name(global.player_name)
	await get_tree().create_timer(0.1).timeout
	GameManager._lvlManager.level_changed.connect(_on_level_change)
	_on_level_change(1)

func _process(_delta: float) -> void:
	_update_time()

func _set_player_name(_name:String):
	player_name_label.text = "Help %s escape!"%_name

func _on_level_change(level_num):
	set_level_data(level_num, levels_instructions[level_num])


func set_level_data( current_level_num:int, instructions:String):
	lvl_instruction_label.text = instructions
	lvl_num_label.text = "%d/%d"%[current_level_num, GameManager.Nlevels]

func _update_time() -> void:
	var minutes = int(GameManager._time) / 60
	var seconds = int(GameManager._time) % 60
	
	time_label.text = "{0}:{1}".format({
		0:"%02d"%minutes,
		1:"%02d"%seconds,
		})
