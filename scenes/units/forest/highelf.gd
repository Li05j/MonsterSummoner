class_name HighElf extends MeleeTroops

var _dodge_cd_timer: Timer
#var _is_dodge_ready: bool = true

func _init_stats() -> void:
	_not_interactable = true
	_is_invincible = true
	
	_is_cc_immune = ForestUnits.highelf_data.cc_immune
	_is_slow_immune = ForestUnits.highelf_data.slow_immune
	
	_cost = ForestUnits.highelf_data.cost
	_gold_drop = Global.get_gold_drop(_cost)
	_move_spd = ForestUnits.highelf_data.move_spd
	_max_hp = ForestUnits.highelf_data.max_hp
	_atk = ForestUnits.highelf_data.atk
	_atk_spd = ForestUnits.highelf_data.atk_spd
	_atk_frame = ForestUnits.highelf_data.atk_frame
	
	_spwn_wait = ForestUnits.highelf_data.spwn_wait
	
	_targets = ForestUnits.highelf_data.targets

func _init_timers() -> void:
	super()
	_dodge_cd_timer = _new_common_timer(_on_dodge_cd_timeout, ForestUnits.highelf_data.dodge_cd)

func _physics_process(delta: float) -> void:
	if !(_not_interactable or _is_dead):
		if global_position.y < Global.ground_y:
			_v_y += Global.gravity * delta
		else:
			global_position.y = Global.ground_y
		_move(delta)

func _move(delta: float) -> void:
	if !_during_special and _cc_count == 0:
		if _if_any_enemy_in_range():
			_attack()
		elif _sprite.animation != "attack":
			_sprite.play("run")
			_v_x = _dir * _move_spd
	
	position.x += _v_x * _spd_scale * delta
	position.y += _v_y * delta
			
	if _v_x == 0 and _sprite.animation == "run":
		_sprite.play("idle")

func _is_valid() -> bool:
	return !(_not_interactable or _is_dead or _during_special)

func _set_ally() -> void:
	super()
	_atk_dmg_box.collision_mask |= Global.Collision.PLAYER_UNIT

func _set_enemy() -> void:
	super()
	_atk_dmg_box.collision_mask |= Global.Collision.ENEMY_UNIT

func _attack_special_effects(enemy) -> void:
	enemy.knockback(ForestUnits.highelf_data.knockback_time)

func _resolve_attack() -> void:
	var valid_enemies = _get_enemies_in_box(_atk_dmg_box)
	
	if valid_enemies.size() == 0:
		return
		
	valid_enemies.sort_custom(
		func(a, b):
			if _who == Global.Who.ALLY:
				return a.global_position.x < b.global_position.x # sort from left to right
			else:
				return a.global_position.x > b.global_position.x # sort from right to left
			)
	
	# 1st target takes 5x damage
	var extra_dmg_done = false
	
	#if is_instance_valid(target) and target._is_valid():
		#_deal_dmg(target, 5.0, 0, self)
	var target
	var idx = 0
	while idx >= 0 and idx < valid_enemies.size():
		target = valid_enemies[idx]
		if is_instance_valid(target) and target._is_valid():
			if _who == target._who:
				target.heal(_atk * 2)
			else:
				if !extra_dmg_done:
					_deal_dmg(target, 5.0)
					extra_dmg_done = true
				else:
					_deal_dmg(target)
		idx += 1

func _take_dmg(damage: int, attacker = null) -> bool:
	if _not_interactable || _is_invincible || _is_dead:
		return false # they don't take damage
	
	if _dodge_cd_timer.is_stopped():
		damage = 1
	_counter(attacker)
	_current_hp -= _final_damage(damage)
	_hurt_reaction()
	if _current_hp <= 0:
		_dead()
		return true
	return false

func _hurt_reaction() -> void:
	super()
	if _dodge_cd_timer.is_stopped():
		_during_special = true
		_v_x = -1 * _dir * _move_spd * 2.25
		_sprite.play("special")

func _on_sprite_animation_finished() -> void:
	super()
	if _sprite.animation == "special":
		_v_x = _dir * _move_spd
		_during_special = false
		_dodge_cd_timer.start()

func _on_dodge_cd_timeout() -> void:
	pass
