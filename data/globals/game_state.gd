extends Node

var player_initial_gold: int = 50
var player_initial_gold_gen: int = 5

var enemy_factions_left: Array = Global.Faction.values()
var playing_as: Global.Faction = Global.Faction.NONE
var total_game_time: float = 0

var total_restarts: int = 0
var ally_base_hp_left: int = Global.max_base_hp

func _ready() -> void:
	EventBus.enemy_base_destroyed.connect(_on_enemy_base_destroyed)

func set_playing_as(faction: Global.Faction) -> void:
	playing_as = faction
	remove_enemy_faction(faction)

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

func remove_enemy_faction(faction: Global.Faction) -> void:
	enemy_factions_left.erase(faction)

func reset_without_changing_faction() -> void:
	LevelState.reset_level_state()
	player_initial_gold = 50
	player_initial_gold_gen = 5
	total_game_time = 0
	enemy_factions_left = Global.Faction.values()
	enemy_factions_left.erase(Global.Faction.NONE)

func restart() -> int:
	total_restarts += 1
	total_game_time -= LevelState.game_time
	return LevelState.restart_level()

func reset_game_state() -> void:
	reset_without_changing_faction()
	playing_as = Global.Faction.NONE

func _on_enemy_base_destroyed() -> void:
	ally_base_hp_left = LevelState.current_level.get_node("Ally_Base")._current_hp
