class_name Protector extends MeleeTroops

# Knockbacks on hit, AOE, takes 3 less dmg from all sources

func _init_stats() -> void:
	_not_interactable = true
	_is_invincible = true
	
	_is_cc_immune = ForestUnits.protector_data.cc_immune
	_is_slow_immune = ForestUnits.protector_data.slow_immune
	
	_cost = ForestUnits.protector_data.cost
	_gold_drop = Global.get_gold_drop(_cost)
	_move_spd = ForestUnits.protector_data.move_spd
	_max_hp = ForestUnits.protector_data.max_hp
	_atk = ForestUnits.protector_data.atk
	_atk_spd = ForestUnits.protector_data.atk_spd
	_atk_frame = ForestUnits.protector_data.atk_frame
	
	_spwn_wait = ForestUnits.protector_data.spwn_wait
	
	_targets = ForestUnits.protector_data.targets
	
	_def = ForestUnits.protector_data.def
	
func _attack_special_effects(enemy) -> void:
	enemy.knockback(ForestUnits.protector_data.knockback_time)
