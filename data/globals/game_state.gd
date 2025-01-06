extends Node

var player_initial_gold: int = 50
var player_initial_gold_gen: int = 5

var playing_as: Global.Faction = Global.Faction.NONE

func set_playing_as(faction: Global.Faction) -> void:
	playing_as = faction

func get_command_panel_scene() -> PackedScene:
	match playing_as:
		Global.Faction.MONSTER:
			return preload(Paths.COMMAND_PANEL + "monster/monster_panel.tscn")
		Global.Faction.DARKNESS:
			return preload(Paths.COMMAND_PANEL + "darkness/darkness_panel.tscn")
		Global.Faction.UNDEAD:
			return preload(Paths.COMMAND_PANEL + "undead/undead_panel.tscn")
		_:
			return null

func reset_game_state() -> void:
	LevelState.reset_level_state()
	
	player_initial_gold = 50
	player_initial_gold_gen = 5

	playing_as = Global.Faction.NONE
