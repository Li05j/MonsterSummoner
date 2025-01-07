class_name StationaryProj extends Projectile

var _atk_frame: int
var _targets: int

func _connect_signals() -> void:
	super()
	_sprite.animation_finished.connect(_on_sprite_animation_finished)
	_sprite.frame_changed.connect(_on_sprite_attack_frame_change)

func _set_initial_velocity() -> void:
	_stationary()

func _set_initial_pos() -> void:
	var enemy = _proj_owner.get("target_enemy_node")
	if enemy:
		global_position = enemy.global_position
	else:
		#global_position = Vector2(abs(_proj_owner._proj_range - _proj_owner.global_position.x), Global.ground_y)
		global_position = Vector2(_proj_owner._proj_range, Global.ground_y)
	_initial_position = global_position

func _resolve_attack() -> void:
	var valid_enemies = _get_enemies_in_box(_hitbox)
	if valid_enemies.size() == 0:
		return
	
	# Hit multiple enemies
	if _targets == -1:
		for target in valid_enemies:
			if is_instance_valid(target) and target._is_valid():
				_proj_owner._deal_dmg(target)
	else:
		# sort from close to far first
		valid_enemies.sort_custom(
			func(a, b):
				if _who == Global.Who.ALLY:
					return a.global_position.x < b.global_position.x # sort from left to right
				else:
					return a.global_position.x > b.global_position.x # sort from right to left
				)
	
		var idx = 0
		var targets_left = _targets
		var base = null
		while targets_left > 0 and idx >= 0 and idx < valid_enemies.size():
			var target = valid_enemies[idx]
			if is_instance_valid(target) and (target is AllyBase or target is EnemyBase):
				base = valid_enemies.pop_at(idx)
				continue
			if is_instance_valid(target) and target._is_valid():
				_proj_owner._deal_dmg(target)
				targets_left -= 1
			idx += 1
		if targets_left:
			if is_instance_valid(base) and base._is_valid():
				_proj_owner._deal_dmg(base)

func _on_hitbox_enter(other: Area2D) -> void:
	pass

func _on_sprite_animation_finished() -> void:
	if _is_valid():
		_dead()

func _on_sprite_attack_frame_change() -> void:
	# Deal damage on a specific attack animation frame
	_hitbox.monitoring = true
	if _is_valid() and _sprite.frame == _atk_frame:
		_resolve_attack()
		_hitbox.monitoring = false
