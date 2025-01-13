class_name NormalBehavior extends EnemyAIBehavior

var _enemy_gold_gen_step = 40

func init(enemy_ai: EnemyAI) -> void:
	super(enemy_ai)
	target_time_till_next_gold_gen_increase = 45
	target_gold_gen_time_step = 25
	
	ai.enemy_gold *= LevelState.level_number
	ai.enemy_gold_gen = max(4 + _current_level, floor(GameState.total_game_time / (_enemy_gold_gen_step + 10 * _current_level)))

func generate_decision_wait_time() -> float:
	return randf_range(0.2, 0.75)
