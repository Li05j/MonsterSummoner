class_name Mage extends ProjTroops

func _init_stats() -> void:
	_not_interactable = true
	_is_invincible = true
	
	_is_cc_immune = HumanUnits.mage_data.cc_immune
	_is_slow_immune = HumanUnits.mage_data.slow_immune
	
	_cost = HumanUnits.mage_data.cost
	_gold_drop = Global.get_gold_drop(_cost)
	_move_spd = HumanUnits.mage_data.move_spd
	_max_hp = HumanUnits.mage_data.max_hp
	_atk = HumanUnits.mage_data.atk
	_atk_spd = HumanUnits.mage_data.atk_spd
	_atk_frame = HumanUnits.mage_data.atk_frame
	
	_spwn_wait = HumanUnits.mage_data.spwn_wait
	
	_targets = HumanUnits.mage_data.targets
	
	#####
	_projectile_scene = preload(Paths.PROJ + "mage_proj.tscn")

func _init_proj_max_range() -> void:
	_max_travel_range = 1.25 * _atk_detect_box.get_child(0).shape.size.x * _sprite.scale.x
	_proj_range = _max_travel_range

func _attack_special_effects(enemy) -> void:
	enemy.stun(HumanUnits.mage_data.stun_time)
