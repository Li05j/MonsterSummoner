class_name Giant extends MeleeTroops

# Knockbacks on hit, AOE, takes 3 less dmg from all sources

func _init_stats() -> void:
	_not_interactable = true
	_is_invincible = true
	
	_is_cc_immune = MonsterUnits.giant_data.cc_immune
	_is_slow_immune = MonsterUnits.giant_data.slow_immune
	
	_cost = MonsterUnits.giant_data.cost
	_gold_drop = Global.get_gold_drop(_cost)
	_move_spd = MonsterUnits.giant_data.move_spd
	_max_hp = MonsterUnits.giant_data.max_hp
	_atk = MonsterUnits.giant_data.atk
	_atk_spd = MonsterUnits.giant_data.atk_spd
	_atk_frame = MonsterUnits.giant_data.atk_frame
	
	_spwn_wait = MonsterUnits.giant_data.spwn_wait
	
	_targets = MonsterUnits.giant_data.targets
	
func _attack_special_effects(enemy) -> void:
	enemy.knockback(1.5)

func _final_damage(damage: int) -> int:
	return max(1, damage - 2)
