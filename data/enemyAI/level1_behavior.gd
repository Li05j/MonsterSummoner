class_name Level1AIBehavior extends EnemyAIBehavior

func init() -> void:
	target_time_till_next_gold_gen_increase = 60
	target_gold_gen_time_step = 20

func get_pot_of_gold_value(critical: int) -> int:
	if critical == 1:
		return max(50, floor(LevelState.game_time))
	if critical == 2:
		return max(100, floor(LevelState.game_time))
	return floor(LevelState.game_time / 5)

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
