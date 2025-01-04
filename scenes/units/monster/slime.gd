class_name Slime extends ProjTroops

func _init_stats() -> void:
	_not_interactable = true
	_is_invincible = true
	
	_is_cc_immune = MonsterUnits.slime_data.cc_immune
	_is_slow_immune = MonsterUnits.slime_data.slow_immune
	
	_cost = MonsterUnits.slime_data.cost
	_gold_drop = Global.get_gold_drop(_cost)
	_move_spd = MonsterUnits.slime_data.move_spd
	_max_hp = MonsterUnits.slime_data.max_hp
	_atk = MonsterUnits.slime_data.atk
	_atk_spd = MonsterUnits.slime_data.atk_spd
	_atk_frame = MonsterUnits.slime_data.atk_frame
	
	_spwn_wait = MonsterUnits.slime_data.spwn_wait
	
	_targets = MonsterUnits.slime_data.targets

	#####
	_projectile_scene = preload(Paths.PROJ + "slime_proj.tscn")
	
func _set_proj_range() -> void:
	_by_distance(true)
