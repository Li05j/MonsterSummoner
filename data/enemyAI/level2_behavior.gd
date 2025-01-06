class_name Level2AIBehavior extends EnemyAIBehavior

func init() -> void:
	target_time_till_next_gold_gen_increase = 45
	target_gold_gen_time_step = 16

func get_pot_of_gold_value(critical: int) -> int:
	if critical == 1:
		return max(85, floor(LevelState.game_time))
	if critical == 2:
		return max(170, floor(LevelState.game_time))
	return floor(LevelState.game_time / 3.9)

func generate_decision_wait_time() -> float:
	return randf_range(0.2, 1.0)
