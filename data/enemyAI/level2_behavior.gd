class_name Level2AIBehavior extends EnemyAIBehavior

func init(enemy_ai: EnemyAI) -> void:
	super(enemy_ai)
	target_time_till_next_gold_gen_increase = 60
	target_gold_gen_time_step = 35

func get_pot_of_gold_value(critical: int) -> int:
	if critical == 1:
		return max(75, floor((GameState.total_game_time + LevelState.game_time) / 3))
	if critical == 2:
		return max(150, floor((GameState.total_game_time + LevelState.game_time) / 3))
	return ai.enemy_gold_gen * 2

func generate_decision_wait_time() -> float:
	return randf_range(0.2, 1.0)
