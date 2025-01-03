class_name Doomsday extends ProjTroops

# Ranged (target farthest) until someone in melee range, then turn into melee only
@onready var _change_to_melee_box = _sprite.get_node("ChangeToMelee")
@onready var _melee_box = _sprite.get_node("MeleeArea")
@onready var _atk_dmg_box = _sprite.get_node("AtkDmgBoxArea")

var _melee: bool = false

func _init_stats() -> void:
	_not_interactable = true
	_is_invincible = true
	
	_is_cc_immune = DarknessUnits.doomsday_data.cc_immune
	_is_slow_immune = DarknessUnits.doomsday_data.slow_immune
	
	_cost = DarknessUnits.doomsday_data.cost
	_gold_drop = floor(_cost / 3.0)
	_move_spd = DarknessUnits.doomsday_data.move_spd
	_max_hp = DarknessUnits.doomsday_data.max_hp
	_atk = DarknessUnits.doomsday_data.atk
	_atk_spd = DarknessUnits.doomsday_data.atk_spd
	_atk_frame = DarknessUnits.doomsday_data.atk_frame
	_cc_rate = DarknessUnits.doomsday_data.cc_rate
	
	_spwn_wait = DarknessUnits.doomsday_data.spwn_wait
	
	_targets = DarknessUnits.doomsday_data.targets
	
	#####
	_projectile_scene = preload(Paths.PROJ + "doomsday_proj.tscn")

func _init_collisions() -> void:
	super()
	_change_to_melee_box.collision_layer = Types.Collision.DETECT_ONLY
	_melee_box.collision_layer = Types.Collision.DETECT_ONLY

func _connect_signals() -> void:
	super()
	_change_to_melee_box.area_entered.connect(_on_change_to_melee_enter)

func _move(delta: float) -> void:
	if _cc_count == 0:
		if _if_any_enemy_in_range():
			_attack()
		elif _sprite.animation != "attack" and _sprite.animation != "special":
			_sprite.play("run")
			_v_x = _dir * _move_spd
			
	position.x += _v_x * _spd_scale * delta
	position.y += _v_y * delta
	
	if _v_x == 0 and _sprite.animation == "run":
		_sprite.play("idle")

func _set_ally() -> void:
	_melee_box.collision_mask = Types.Collision.ENEMY_UNIT | Types.Collision.ENEMY_BASE
	super()

func _set_enemy() -> void:
	_melee_box.collision_mask = Types.Collision.PLAYER_UNIT | Types.Collision.PLAYER_BASE
	super()

func _change_to_melee() -> void:
	_change_to_melee_box.queue_free()
	
	_atk_spd *= DarknessUnits.doomsday_data.melee_atk_spd_rate
	_attack_cd_timer.wait_time = _atk_spd
	
	_atk *= DarknessUnits.doomsday_data.melee_atk_rate
	_atk_frame = DarknessUnits.doomsday_data.melee_atk_frame
	_targets = DarknessUnits.doomsday_data.melee_targets
	
	_atk_detect_box.visible = false
	_atk_detect_box = _melee_box
	
	if !_attack_cd_timer.is_stopped():
		_attack_cd_timer.stop()
	
	_melee = true

func _set_proj_range() -> void:
	_by_distance(false)

func _by_distance(closest: bool) -> void:
	var valid_enemies_x = _get_detect_box_enemies_x()
	valid_enemies_x.sort_custom(
		func(a, b): 
			return a < b if closest else b < a
	)
	if valid_enemies_x.size():
		_proj_range = valid_enemies_x[0]
	else:
		_proj_range = _max_travel_range

func _resolve_attack() -> void:
	if _melee:
		var valid_enemies = []
		for area in _atk_dmg_box.get_overlapping_areas():
			if !is_instance_valid(area):
				continue
			
			var enemy_node = area.get_parent().get_parent()
			if is_instance_valid(enemy_node):
				if enemy_node._is_valid():
					valid_enemies.append(enemy_node)
	
		if valid_enemies.size() == 0:
			return
	
		# sort from close to far first
		valid_enemies.sort_custom(
			func(a, b): 
				return a.global_position.x > b.global_position.x
				)
	
		var target = valid_enemies[0]
		if is_instance_valid(target) and target._is_valid():
			_deal_dmg(target)
	else:
		super()

func _attack() -> void:
	if _is_valid() and _cc_count == 0:
		_v_x = 0
		if _attack_cd_timer.is_stopped():
			if _melee:
				_sprite.play("attack")
			else:
				_sprite.play("special")

func _on_change_to_melee_enter(other: Area2D) -> void:
	if !_melee:
		_change_to_melee()

func _on_sprite_animation_finished() -> void:
	super()
	if _is_valid() and _sprite.animation == "special":
		_sprite.play("idle")  	# Idle while waiting for next attack
		_attack_cd_timer.start()	# Basic attack cooldown

func _on_sprite_attack_frame_change() -> void:
	# Deal damage on a specific attack animation frame
	if _melee:
		_atk_dmg_box.monitoring = true
		if _is_valid() and _sprite.animation == "attack" and _sprite.frame == _atk_frame:
			_resolve_attack()
			_atk_dmg_box.monitoring = false
	elif _is_valid() and _sprite.animation == "special" and _sprite.frame == _atk_frame:
		_resolve_attack()
