extends Node

const MAX_LVL_NUMBER = 3

var who_wins: Global.Who = Global.Who.NONE

var current_level = null
var level_number: int = 0

var current_enemy_faction: Global.Faction = Global.Faction.NONE
var enemy_ai: EnemyAI = null
var ally_base_pos = Vector2.ZERO
var enemy_base_pos = Vector2.ZERO

var game_time: float = 0

var player_gold = 50
var player_gold_gen = 5

var restarts: int = 0

func _ready():
	EventBus.unit_died.connect(_on_unit_died)

func _on_unit_died(who, gold_drop):
	if who == Global.Who.ENEMY:
		player_gold += gold_drop
		EventBus.player_gold_text_changed.emit()

func reset_level_state() -> void:
	_weak_reset()
	
	current_level = null
	level_number = 0
	
	current_enemy_faction = Global.Faction.NONE
	enemy_ai = null
	ally_base_pos = Vector2.ZERO
	enemy_base_pos = Vector2.ZERO
	
	restarts = 0

func restart_level() -> void:
	restarts += 1
	set_level(level_number)

func next_level() -> void:
	restarts = 0
	set_level(level_number + 1)

func _weak_reset() -> void:
	who_wins = Global.Who.NONE
	game_time = 0
	player_gold = GameState.player_initial_gold
	player_gold_gen = GameState.player_initial_gold_gen

func set_level(lvl: int):
	_weak_reset()
	level_number = lvl
