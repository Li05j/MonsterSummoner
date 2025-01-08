class_name Level1AIBehavior extends EnemyAIBehavior

func init(enemy_ai: EnemyAI) -> void:
	super(enemy_ai)
	target_time_till_next_gold_gen_increase = 90
	target_gold_gen_time_step = 40

func get_pot_of_gold_value(critical: int) -> int:
	if critical == 1:
		return max(30, floor((GameState.total_game_time + LevelState.game_time) / 4))
	if critical == 2:
		return max(60, floor((GameState.total_game_time + LevelState.game_time) / 4))
	return ai.enemy_gold_gen

func generate_decision_wait_time() -> float:
	return randf_range(0.5, 1.0)

 #0 = do nothing, 1-4 summon respective unit
func decide_what_to_do() -> int:
	var rand = randi_range(0,13)
	match rand:
		1: 
			if ai._check_if_affordable(u1cost):
				return 1
		2: 			
			if ai._check_if_affordable(u2cost):
				return 2
		3: 			
			if ai._check_if_affordable(u3cost):
				return 3
		_: 			
			if ai._check_if_affordable(u4cost):
				return 4
	return 0
