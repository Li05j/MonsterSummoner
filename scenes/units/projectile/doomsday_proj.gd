class_name DoomsdayProj extends Projectile

var _atk_frame = 7

func _ready() -> void:
	super()

func _connect_signals() -> void:
	super()
	_sprite.animation_finished.connect(_on_sprite_animation_finished)
	_sprite.frame_changed.connect(_on_sprite_attack_frame_change)

func _set_initial_velocity() -> void:
	_stationary()

func _set_initial_pos() -> void:
	global_position = Vector2(_proj_owner._proj_range, Types.ground_y)
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
	for target in valid_enemies:
		if is_instance_valid(target) and target._is_valid():
			_proj_owner._deal_dmg(target)

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
