class_name Iceworm extends ProjTroops

func _init_stats() -> void:
	_not_interactable = true
	_is_invincible = true
	
	_is_cc_immune = MonsterUnits.iceworm_data.cc_immune
	_is_slow_immune = MonsterUnits.iceworm_data.slow_immune
	
	_cost = MonsterUnits.iceworm_data.cost
	_gold_drop = floor(_cost / 3.0)
	_move_spd = MonsterUnits.iceworm_data.move_spd
	_max_hp = MonsterUnits.iceworm_data.max_hp
	_atk = MonsterUnits.iceworm_data.atk
	_atk_spd = MonsterUnits.iceworm_data.atk_spd
	_atk_frame = MonsterUnits.iceworm_data.atk_frame
	
	_spwn_wait = MonsterUnits.iceworm_data.spwn_wait
	
	_targets = MonsterUnits.iceworm_data.targets
	
	#####
	_projectile_scene = preload(Paths.PROJ + "iceworm_proj.tscn")
	
func _init_proj_max_range() -> void:
	_max_travel_range = 1.75 * _atk_detect_box.get_child(0).shape.size.x * _sprite.scale.x
	_proj_range = _max_travel_range

func _attack_special_effects(enemy) -> void:
	enemy.slow(2.0) # slow for x seconds
