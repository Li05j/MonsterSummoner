class_name Goblin extends MeleeTroops

func _init_stats() -> void:
	_not_interactable = true
	_is_invincible = true
	
	_is_cc_immune = MonsterUnits.goblin_data.cc_immune
	_is_slow_immune = MonsterUnits.goblin_data.slow_immune
	
	_cost = MonsterUnits.goblin_data.cost
	_gold_drop = floor(_cost / 3.0)
	_move_spd = MonsterUnits.goblin_data.move_spd
	_max_hp = MonsterUnits.goblin_data.max_hp
	_atk = MonsterUnits.goblin_data.atk
	_atk_spd = MonsterUnits.goblin_data.atk_spd
	_atk_frame = MonsterUnits.goblin_data.atk_frame
	
	_spwn_wait = MonsterUnits.goblin_data.spwn_wait
	
	_targets = MonsterUnits.goblin_data.targets
	
	var rand = randi_range(0, 4)
	if !rand:	# 1 in 4 it summons big goblin
		_max_hp *= 1.2
		_atk *= 1.2
		_sprite.scale *= 1.4
		_hp_bar.position.y = -150
