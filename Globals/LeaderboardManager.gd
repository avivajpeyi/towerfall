extends Node

var leaderboard_data:Dictionary
var N_completions:int
var player_ranking:int

signal leaderboard_data_updated
signal player_data_posted

var posting_allowed:bool = false

func _ready():
	_connect_to_leaderboard()
	_get_top_scores()


func _connect_to_leaderboard():
	print("Connecting to leaderboard")
	SilentWolf.configure({
		"api_key": "xRcZ5BFPDK5AyEzuDjVmXaF8u4u1iA7UPNNX8KP6",
		"game_id": "towerfall",
		"log_level": 1
	})
	

func _clear_leaderboard():
	SilentWolf.Scores.wipe_leaderboard()

	
func _post_score(score:float):
	if !posting_allowed:
		print("SCORE POSTING DISABLED")
		return 
	print("psting score ", score)
	var score_to_save = score*-1
	var sw_result: Dictionary = await SilentWolf.Scores.save_score(global.player_name, score_to_save).sw_save_score_complete
	print("Score persisted successfully: " + str(sw_result.score_id))
	print("Getting position for score ", score_to_save)
	sw_result = await SilentWolf.Scores.get_score_position(score_to_save).sw_get_position_complete
	player_ranking = sw_result.position
	print(sw_result)
	print("%s ranks %d"%([global.player_name, player_ranking]))
	player_data_posted.emit()
	_get_top_scores()
	

func _get_top_scores():
	leaderboard_data = await SilentWolf.Scores.get_scores(0).sw_get_scores_complete
	print("All scores: " + str(leaderboard_data.scores))
	N_completions = len(leaderboard_data.scores)
	leaderboard_data_updated.emit()
