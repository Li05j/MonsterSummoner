class_name ConserveAIBehavior extends EnemyAIBehavior

func generate_decision_wait_time() -> float:
	return randf_range(0.2, 1.0)

# 0 = do nothing, 1-4 summon respective unit
func decide_what_to_do() -> int:
	var rand = randi_range(0,13)
	match rand:
		1: return 1
		2: return 2
		3: return 2
		4: return 2
		_: return 0
