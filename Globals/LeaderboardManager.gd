extends Node

var leaderboard_data:Dictionary
var N_completions:int
var player_ranking:int

signal data_downloaded

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
	

	
func _post_score(score:float):
	print("psting score ", score)
	var sw_result: Dictionary = await SilentWolf.Scores.save_score(global.player_name, score).sw_save_score_complete
	print("Score persisted successfully: " + str(sw_result.score_id))
	sw_result = await SilentWolf.Scores.get_score_position(score).sw_get_position_complete
	player_ranking = sw_result.position
	print("%s ranks %d"%([global.player_name, player_ranking]))
	data_downloaded.emit()
	

func _get_top_scores():
	leaderboard_data = await SilentWolf.Scores.get_scores(0).sw_get_scores_complete
	print("All scores: " + str(leaderboard_data.scores))
	N_completions = len(leaderboard_data.scores)
