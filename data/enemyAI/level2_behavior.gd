class_name Level2AIBehavior extends EnemyAIBehavior

func init(enemy_ai: EnemyAI) -> void:
	super(enemy_ai)
	target_time_till_next_gold_gen_increase = 90
	target_gold_gen_time_step = 45

func get_pot_of_gold_value(critical: int) -> int:
	if critical == 1:
		return max(50, floor(LevelState.game_time / 4.2))
	if critical == 2:
		return max(100, floor(LevelState.game_time / 4.2))
	return ai.enemy_gold_gen * 2

func generate_decision_wait_time() -> float:
	return randf_range(0.2, 1.0)
