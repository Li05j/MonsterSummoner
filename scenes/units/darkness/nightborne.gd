class_name Nightborne extends MeleeTroops

# Dashes upon first contact and AOE on death

var _dashed: bool = false
const _dead_frame = 12

func _ready() -> void:
	_not_interactable = true
	_is_invincible = true
	_is_cc_immune = false
	_is_slow_immune = false
	
	_cost = 65
	_gold_drop = floor(_cost / 3.0)
	_move_spd = 100
	_max_hp = 76
	_atk = 11
	_atk_spd = 1.4
	_atk_frame = 9
	
	_spwn_wait = 0.75
	
	_targets = 2
	
	super()

func _physics_process(delta: float) -> void:
	if !(_not_interactable or _is_dead):
		if global_position.y < Types.ground_y:
			_v_y += Types.gravity * delta
		else:
			#_v_y = 0
			global_position.y = Types.ground_y
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
	
	if _during_special:
		var x = global_position.x
		if x < LevelState.ally_base_pos.x:
			global_position.x = LevelState.ally_base_pos.x
		elif x > LevelState.enemy_base_pos.x:
			global_position.x = LevelState.enemy_base_pos.x
			
	if _v_x == 0 and _sprite.animation == "run":
		_sprite.play("idle")

func _is_valid() -> bool:
	return !(_not_interactable or _is_dead or _during_special)

func _hurt_reaction() -> void:
	super()
	if !_dashed and get_hp_percent() <= 0.75:
		_during_special = true
		_v_x = _dir * _move_spd * 2.25
		_sprite.play("special")

func _on_sprite_animation_finished() -> void:
	super()
	if _sprite.animation == "special":
		_v_x = _dir * _move_spd
		_dashed = true
		_during_special = false

func _on_sprite_attack_frame_change() -> void:
	# Deal damage on a specific attack animation frame
	_atk_dmg_box.monitoring = true
	if _is_valid() and _sprite.animation == "attack" and _sprite.frame == _atk_frame:
		_resolve_attack()
		_atk_dmg_box.monitoring = false
		
	if _sprite.animation == "dead" and _sprite.frame == _dead_frame:
		_atk *= 2
		var explosion_area = _sprite.get_node("DeathExplosionArea")
		
		var valid_enemies = []
		for area in explosion_area.get_overlapping_areas():
			if !is_instance_valid(area):
				continue
			
			var enemy_node = area.get_parent().get_parent()
			if is_instance_valid(enemy_node):
				if enemy_node._is_valid():
					valid_enemies.append(enemy_node)
	
			if valid_enemies.size() == 0:
				return
	
			# Hit all enemies
			for target in valid_enemies:
				if is_instance_valid(target) and target._is_valid():
					_deal_dmg(target)
