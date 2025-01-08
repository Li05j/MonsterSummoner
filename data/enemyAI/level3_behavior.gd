class_name Level3AIBehavior extends EnemyAIBehavior

func init(enemy_ai: EnemyAI) -> void:
	super(enemy_ai)
	target_time_till_next_gold_gen_increase = 45
	target_gold_gen_time_step = 30

func get_pot_of_gold_value(critical: int) -> int:
	if critical == 1:
		return max(100, floor((GameState.total_game_time + LevelState.game_time) / 2.5))
	if critical == 2:
		return max(200, floor((GameState.total_game_time + LevelState.game_time) / 2.5))
	return ai.enemy_gold_gen * 3

func generate_decision_wait_time() -> float:
	if ai.critical_2_flag:
		return randf_range(0.2, 0.75)
	else:
		return randf_range(0.2, 1.0)
