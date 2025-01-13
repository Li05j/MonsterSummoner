class_name HighElf extends MeleeTroops

func _init_stats() -> void:
	_not_interactable = true
	_is_invincible = true
	
	_is_cc_immune = ForestUnits.highelf_data.cc_immune
	_is_slow_immune = ForestUnits.highelf_data.slow_immune
	
	_cost = ForestUnits.highelf_data.cost
	_gold_drop = Global.get_gold_drop(_cost)
	_move_spd = ForestUnits.highelf_data.move_spd
	_max_hp = ForestUnits.highelf_data.max_hp
	_atk = ForestUnits.highelf_data.atk
	_atk_spd = ForestUnits.highelf_data.atk_spd
	_atk_frame = ForestUnits.highelf_data.atk_frame
	
	_spwn_wait = ForestUnits.highelf_data.spwn_wait
	
	_targets = ForestUnits.highelf_data.targets

func _attack_special_effects(enemy) -> void:
	var rand = randi_range(0, 3)
	if !rand:
		enemy.stun(1.0)
