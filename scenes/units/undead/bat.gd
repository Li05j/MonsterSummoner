class_name Bat extends MeleeTroops

func _init_stats() -> void:
	_not_interactable = true
	_is_invincible = true
	
	_is_cc_immune = UndeadUnits.bat_data.cc_immune
	_is_slow_immune = UndeadUnits.bat_data.slow_immune
	
	_cost = UndeadUnits.bat_data.cost
	_gold_drop = Global.get_gold_drop(_cost)
	_move_spd = UndeadUnits.bat_data.move_spd
	_max_hp = UndeadUnits.bat_data.max_hp
	_atk = UndeadUnits.bat_data.atk
	_atk_spd = UndeadUnits.bat_data.atk_spd
	_atk_frame = UndeadUnits.bat_data.atk_frame
	
	_spwn_wait = UndeadUnits.bat_data.spwn_wait
	
	_targets = UndeadUnits.bat_data.targets

func _init_misc() -> void:
	super()
	a_summon = true
