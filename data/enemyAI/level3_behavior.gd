class_name Level3AIBehavior extends EnemyAIBehavior

func init(enemy_ai: EnemyAI) -> void:
	super(enemy_ai)
	target_time_till_next_gold_gen_increase = 60
	target_gold_gen_time_step = 30

func get_pot_of_gold_value(critical: int) -> int:
	if critical == 1:
		return max(75, floor(LevelState.game_time / 3.6))
	if critical == 2:
		return max(150, floor(LevelState.game_time / 3.6))
	return ai.enemy_gold_gen * 3

func generate_decision_wait_time() -> float:
	if ai.critical_2_flag:
		return randf_range(0.2, 0.75)
	else:
		return randf_range(0.2, 1.0)
