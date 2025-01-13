class_name EnemyAIBehavior extends Resource

var ai: EnemyAI

#var enemy_base_hp = 500

var _critical_hp_gold_rate = 0.27

var _min_pot = 50
var _max_pot = _min_pot + 50
var _pot_of_gold_rate = 2.7

const critical_hp_1: float = 0.66
const critical_hp_2: float = 0.33

const pot_of_gold_time: int = 30

var target_time_till_next_gold_gen_increase: int = 45
var target_gold_gen_time_step: int = 15

var u1cost
var u2cost
var u3cost
var u4cost

var _current_level

func init(enemy_ai: EnemyAI) -> void:
	set_ai(enemy_ai)
	
	_current_level = LevelState.level_number
	
	_min_pot *= _current_level
	_max_pot = _min_pot + 50
	
	_critical_hp_gold_rate += _current_level * 0.04
	_pot_of_gold_rate += _current_level * 0.4
	
	#enemy_base_hp *= _current_level

func set_ai(enemy_ai: EnemyAI) -> void:
	ai = enemy_ai
	u1cost = ai.unit1_data.cost
	u2cost = ai.unit2_data.cost
	u3cost = ai.unit3_data.cost
	u4cost = ai.unit4_data.cost

func get_pot_of_gold_value(critical: int) -> int:
	if critical == 1:
		return max(_min_pot, floor((GameState.total_game_time + LevelState.game_time) * _critical_hp_gold_rate))
	if critical == 2:
		return max(_max_pot, floor((GameState.total_game_time + LevelState.game_time) * _critical_hp_gold_rate))
	return ai.enemy_gold_gen * _pot_of_gold_rate

func generate_decision_wait_time() -> float:
	return randf_range(0.2, 0.75)

# 0 = do nothing, 1-4 summon respective unit
func decide_what_to_do() -> int:
	var w1 = 10
	var w2 = 10
	var w3 = 25
	var w4 = 50
	var nan = 100
	
	if !ai._check_if_affordable(u4cost):
		w4 = 0
	if !ai._check_if_affordable(u3cost):
		w3 = 0
	if !ai._check_if_affordable(u2cost):
		w2 = 0
	if !ai._check_if_affordable(u1cost):
		w1 = 0
	
	if ai.enemy_gold > u4cost * 1.2:
		w4 *= 4
	
	if ai.critical_2_flag:
		nan /= 2
	
	var min = 0
	var max = w1 + w2 + w3 + w4 + nan
	var cummulative = w1
	
	var rand = randi_range(min, max)
	if rand < cummulative:
		return 1
	cummulative += w2
	if rand < cummulative:
		return 2
	cummulative += w3
	if rand < cummulative:
		return 3
	cummulative += w4
	if rand < cummulative:
		return 4
	return 0
