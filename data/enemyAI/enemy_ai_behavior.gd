class_name EnemyAIBehavior extends Resource

var ai: EnemyAI

const critical_hp_1: float = 0.66
const critical_hp_2: float = 0.33

const pot_of_gold_time: int = 30

var target_time_till_next_gold_gen_increase: int = 45
var target_gold_gen_time_step: int = 15

var u1cost
var u2cost
var u3cost
var u4cost

func set_ai(enemy_ai: EnemyAI) -> void:
	ai = enemy_ai
	u1cost = ai.unit1_data.cost
	u2cost = ai.unit2_data.cost
	u3cost = ai.unit3_data.cost
	u4cost = ai.unit4_data.cost

func get_pot_of_gold_value(critical: int) -> int:
	if critical == 1:
		return max(100, floor(LevelState.game_time))
	if critical == 2:
		return max(200, floor(LevelState.game_time))
	return floor(LevelState.game_time / 3.5)

func generate_decision_wait_time() -> float:
	return 0.1

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
	
	if ai.enemy_gold > u4cost * 1.25:
		w4 *= 5
	
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
