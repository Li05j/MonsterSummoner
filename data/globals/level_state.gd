extends Node

var game_time: float = 0

var player_gold = 50
var player_gold_gen = 5

func reset_level_state() -> void:
	game_time = 0
	player_gold = 50
	player_gold_gen = 5
