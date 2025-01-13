class_name ForestMage extends MeleeTroops

func _init_stats() -> void:
	_not_interactable = true
	_is_invincible = true
	
	_is_cc_immune = ForestUnits.forestmage_data.cc_immune
	_is_slow_immune = ForestUnits.forestmage_data.slow_immune
	
	_cost = ForestUnits.forestmage_data.cost
	_gold_drop = Global.get_gold_drop(_cost)
	_move_spd = ForestUnits.forestmage_data.move_spd
	_max_hp = ForestUnits.forestmage_data.max_hp
	_atk = ForestUnits.forestmage_data.atk
	_atk_spd = ForestUnits.forestmage_data.atk_spd
	_atk_frame = ForestUnits.forestmage_data.atk_frame
	
	_spwn_wait = ForestUnits.forestmage_data.spwn_wait
	
	_targets = ForestUnits.forestmage_data.targets
