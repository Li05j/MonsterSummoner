class_name UndeadWitch extends ProjTroops

func _init_stats() -> void:
	_not_interactable = true
	_is_invincible = true
	
	_is_cc_immune = UndeadUnits.undead_witch_data.cc_immune
	_is_slow_immune = UndeadUnits.undead_witch_data.slow_immune
	
	_cost = UndeadUnits.undead_witch_data.cost
	_gold_drop = Global.get_gold_drop(_cost)
	_move_spd = UndeadUnits.undead_witch_data.move_spd
	_max_hp = UndeadUnits.undead_witch_data.max_hp
	_atk = UndeadUnits.undead_witch_data.atk
	_atk_spd = UndeadUnits.undead_witch_data.atk_spd
	_atk_frame = UndeadUnits.undead_witch_data.atk_frame
	
	_spwn_wait = UndeadUnits.undead_witch_data.spwn_wait
	
	_targets = UndeadUnits.undead_witch_data.targets
	
	#####
	_projectile_scene = preload(Paths.PROJ + "undeadwitch_proj.tscn")
	
func _init_proj_max_range() -> void:
	_max_travel_range = 1.1 * _atk_detect_box.get_child(0).shape.size.x * _sprite.scale.x
	_proj_range = _max_travel_range

func _attack_special_effects(enemy) -> void:
	var rand = randi_range(0,1)
	if rand:
		enemy.fear(UndeadUnits.undead_witch_data.fear_duration)
