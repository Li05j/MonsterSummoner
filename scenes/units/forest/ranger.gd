class_name Ranger extends ProjTroops

func _init_stats() -> void:
	_not_interactable = true
	_is_invincible = true
	
	_is_cc_immune = ForestUnits.ranger_data.cc_immune
	_is_slow_immune = ForestUnits.ranger_data.slow_immune
	
	_cost = ForestUnits.ranger_data.cost
	_gold_drop = Global.get_gold_drop(_cost)
	_move_spd = ForestUnits.ranger_data.move_spd
	_max_hp = ForestUnits.ranger_data.max_hp
	_atk = ForestUnits.ranger_data.atk
	_atk_spd = ForestUnits.ranger_data.atk_spd
	_atk_frame = ForestUnits.ranger_data.atk_frame
	
	_spwn_wait = ForestUnits.ranger_data.spwn_wait
	
	_targets = ForestUnits.ranger_data.targets
	
	#####
	_projectile_scene = preload(Paths.PROJ + "shadowarcher_proj.tscn")
	
func _init_proj_max_range() -> void:
	_max_travel_range = 1.1 * _atk_detect_box.get_child(0).shape.size.x * _sprite.scale.x
	_proj_range = _max_travel_range
