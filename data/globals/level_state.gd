extends Node

var who_wins: Global.Who = Global.Who.NONE

var current_level = null
var enemy_ai: EnemyAI = null
var ally_base_pos = Vector2.ZERO
var enemy_base_pos = Vector2.ZERO

var game_time: float = 0

var player_gold = 50
var player_gold_gen = 5

func _ready():
	EventBus.unit_died.connect(_on_unit_died)

func _on_unit_died(who, gold_drop):
	if who == Global.Who.ENEMY:
		player_gold += gold_drop
		EventBus.player_gold_text_changed.emit()

func reset_level_state() -> void:
	who_wins = Global.Who.NONE
	
	current_level = null
	enemy_ai = null
	ally_base_pos = Vector2(115, 530)
	enemy_base_pos = Vector2(1037, 530)
	
	game_time = 0
	player_gold = 50
	player_gold_gen = 5
