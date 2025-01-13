class_name ForestMage extends MeleeTroops

func _init_stats() -> void:
	_not_interactable = true
	_is_invincible = true
	
	_is_cc_immune = ForestUnits.forestmage_data.cc_immune
	_is_slow_immune = ForestUnits.forestmage_data.slow_immune
	
	_cost = ForestUnits.forestmage_data.cost
	_gold_drop = Global.get_gold_drop(_cost)
	_move_spd = ForestUnits.forestmage_data.move_spd
	_max_hp = ForestUnits.forestmage_data.max_hp
	_atk = ForestUnits.forestmage_data.atk
	_atk_spd = ForestUnits.forestmage_data.atk_spd
	_atk_frame = ForestUnits.forestmage_data.atk_frame
	
	_spwn_wait = ForestUnits.forestmage_data.spwn_wait
	
	_targets = ForestUnits.forestmage_data.targets

func _set_ally() -> void:
	super()
	_atk_dmg_box.collision_mask |= Global.Collision.PLAYER_UNIT

func _set_enemy() -> void:
	super()
	_atk_dmg_box.collision_mask |= Global.Collision.ENEMY_UNIT

func _resolve_attack() -> void:
	var valid_enemies = _get_enemies_in_box(_atk_dmg_box)
	if valid_enemies.size() == 0:
		return
	
	# Hit multiple enemies
	if _targets == -1:
		for target in valid_enemies:
			if is_instance_valid(target) and target._is_valid():
				if _who == target._who:
					target.heal(_atk * 1.5)
				else:
					_deal_dmg(target)

func _attack_special_effects(enemy) -> void:
	enemy.slow(ForestUnits.forestmage_data.slow_time) # slow for x seconds
