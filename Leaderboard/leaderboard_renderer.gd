extends ScrollContainer

const ScoreItem = preload("SmallScoreItem.tscn")

@onready var board = $ScoreItemContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	LeaderboardManager.leaderboard_data_updated.connect(_on_leaderboard_data_updated)
	LeaderboardManager.player_data_posted.connect(_make_visible)
	

func _make_visible():
	visible = true


func _clear_old_enteries():
	for child in board.get_children():
		board.remove_child(child)
		child.queue_free()

func _on_leaderboard_data_updated():
	var list_index:int = 1
	_clear_old_enteries()
	print("LEADERBOARD")
	for score in LeaderboardManager.leaderboard_data.scores:
		print(score)
		var time_score:String = global.float_to_time_str(float(score.score)*-1)
		add_item(score.player_name, time_score, list_index)
		list_index += 1


func add_item(player_name: String, score: String, list_index: int) -> void:
	var item = ScoreItem.instantiate()
	item.get_node("PlayerName").text = str(list_index) + str(". ") + player_name
	item.get_node("Score").text = score
	item.offset_top = list_index * 100
	board.add_child(item)
