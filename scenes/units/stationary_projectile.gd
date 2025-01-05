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
	global_position = Vector2(abs(_proj_owner._proj_range - _proj_owner.global_position.x), Global.ground_y)
	_initial_position = global_position

func _resolve_attack() -> void:
	var valid_enemies = []
	for area in _hitbox.get_overlapping_areas():
		if !is_instance_valid(area):
			continue
			
		var enemy_node = area.get_parent().get_parent()
		if is_instance_valid(enemy_node):
			if enemy_node._is_valid():
				valid_enemies.append(enemy_node)
	
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
				return a.global_position.x < b.global_position.x
				)
	
		var idx = 0
		var targets_left = _targets
		if _who == Global.Who.ENEMY:
			idx = valid_enemies.size() - 1
	
		while targets_left > 0:
			if idx < 0 or idx >= valid_enemies.size():
				break
			var target = valid_enemies[idx]
			if is_instance_valid(target) and target._is_valid():
				_proj_owner._deal_dmg(target)
				targets_left -= 1
			idx += _dir

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
