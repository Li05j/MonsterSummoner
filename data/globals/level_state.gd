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

func restart_level() -> int:
	restarts += 1
	match level_number:
		1: return _set_level_1()
		2: return _set_level_2()
		3: return _set_level_3()
		_: return _set_level_1()

func next_level() -> int:
	restarts = 0
	match level_number:
		1: return _set_level_2()
		2: return _set_level_3()
		_: return _set_level_1()

func _weak_reset() -> void:
	who_wins = Global.Who.NONE
	game_time = 0
	player_gold = GameState.player_initial_gold
	player_gold_gen = GameState.player_initial_gold_gen

func _set_level_1() -> int:
	_weak_reset()
	level_number = 1
	#ally_base_pos = Vector2(Global.ally_base_x, Global.ground_y)
	#enemy_base_pos = Vector2(1037, Global.ground_y)
	return 1

func _set_level_2() -> int:
	_weak_reset()
	level_number = 2
	#ally_base_pos = Vector2(Global.ally_base_x, Global.ground_y)
	#enemy_base_pos = Vector2(2189, Global.ground_y)
	return 2

func _set_level_3() -> int:
	_weak_reset()
	level_number = 3
	#ally_base_pos = Vector2(Global.ally_base_x, Global.ground_y)
	#enemy_base_pos = Vector2(1728, Global.ground_y)
	return 3
