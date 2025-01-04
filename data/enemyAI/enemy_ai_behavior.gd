class_name EnemyAIBehavior extends Resource

var ai: EnemyAI

const critical_hp_1: float = 0.65
const critical_hp_2: float = 0.3

const pot_of_gold_time: int = 60

var target_time_till_next_gold_gen_increase: int = 40
var target_gold_gen_time_step: int = 10

func set_ai(enemy_ai: EnemyAI) -> void:
	ai = enemy_ai

func get_pot_of_gold_value(critical: int) -> int:
	if critical == 1:
		return max(150, floor(LevelState.game_time))
	if critical == 2:
		return max(300, floor(LevelState.game_time))
	return floor(LevelState.game_time / 2)

func generate_decision_wait_time() -> float:
	return randf_range(0.2, 1.0)

# 0 = do nothing, 1-4 summon respective unit
func decide_what_to_do() -> int:
	return 0
