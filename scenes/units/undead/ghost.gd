class_name Ghost extends FarthestTargetProjTroops

# Ranged (target farthest) until someone in melee range, then turn into melee only
func _init_stats() -> void:
	_not_interactable = true
	_is_invincible = true
	
	_is_cc_immune = UndeadUnits.ghost_data.cc_immune
	_is_slow_immune = UndeadUnits.ghost_data.slow_immune
	
	_cost = UndeadUnits.ghost_data.cost
	_gold_drop = Global.get_gold_drop(_cost)
	_move_spd = UndeadUnits.ghost_data.move_spd
	_max_hp = UndeadUnits.ghost_data.max_hp
	_atk = UndeadUnits.ghost_data.atk
	_atk_spd = UndeadUnits.ghost_data.atk_spd
	_atk_frame = UndeadUnits.ghost_data.atk_frame
	
	_spwn_wait = UndeadUnits.ghost_data.spwn_wait
	
	_targets = UndeadUnits.ghost_data.targets
	
	#####
	_projectile_scene = preload(Paths.PROJ + "ghost_proj.tscn")

func _set_proj_range() -> void:
	_by_distance(false)
