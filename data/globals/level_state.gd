extends Node

var who_wins: Types.Who = Types.Who.NONE

var current_level = null

var game_time: float = 0

var player_gold = 50
var player_gold_gen = 5

func reset_level_state() -> void:
	who_wins = Types.Who.NONE
	current_level = null
	
	game_time = 0
	player_gold = 50
	player_gold_gen = 5
