class_name EnemyAIBehavior extends Resource

var ai: EnemyAI

const critical_hp_1: float = 0.65
const critical_hp_2: float = 0.3

const pot_of_gold_time: int = 30

var target_time_till_next_gold_gen_increase: int = 35
var target_gold_gen_time_step: int = 15

func set_ai(enemy_ai: EnemyAI) -> void:
	ai = enemy_ai

func get_pot_of_gold_value(critical: int) -> int:
	if critical == 1:
		return max(85, floor(LevelState.game_time))
	if critical == 2:
		return max(170, floor(LevelState.game_time))
	return floor(LevelState.game_time / 3.6)

func generate_decision_wait_time() -> float:
	return 0.1

# 0 = do nothing, 1-4 summon respective unit
func decide_what_to_do() -> int:
	return 0
