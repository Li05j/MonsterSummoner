class_name Ranger extends ProjTroops

func _init_stats() -> void:
	_not_interactable = true
	_is_invincible = true
	
	_is_cc_immune = DarknessUnits.shadowarcher_data.cc_immune
	_is_slow_immune = DarknessUnits.shadowarcher_data.slow_immune
	
	_cost = DarknessUnits.shadowarcher_data.cost
	_gold_drop = Global.get_gold_drop(_cost)
	_move_spd = DarknessUnits.shadowarcher_data.move_spd
	_max_hp = DarknessUnits.shadowarcher_data.max_hp
	_atk = DarknessUnits.shadowarcher_data.atk
	_atk_spd = DarknessUnits.shadowarcher_data.atk_spd
	_atk_frame = DarknessUnits.shadowarcher_data.atk_frame
	
	_spwn_wait = DarknessUnits.shadowarcher_data.spwn_wait
	
	_targets = DarknessUnits.shadowarcher_data.targets
	
	#####
	_projectile_scene = preload(Paths.PROJ + "shadowarcher_proj.tscn")
	
func _init_proj_max_range() -> void:
	_max_travel_range = 1.1 * _atk_detect_box.get_child(0).shape.size.x * _sprite.scale.x
	_proj_range = _max_travel_range

func _attack_special_effects(enemy) -> void:
	var rand = randi_range(0, 3)
	if !rand:
		enemy.stun(1.0)
