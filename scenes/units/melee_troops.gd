class_name MeleeTroops extends BaseTroops

@onready var _atk_dmg_box = _sprite.get_node("AtkDmgBoxArea")

##########################################################
##### States #####

##### Stats #####

##### Others #####

###########################################################

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_init_stats()
	_init_timers()
	_init_collisions()
	_init_misc()
	_connect_signals()

func _set_ally() -> void:
	add_to_group("ally_unit")
	_spawn.flip_h = false
	_dir = 1
	_hitbox.collision_layer = Global.Collision.PLAYER_UNIT
	_hitbox.collision_mask = Global.Collision.ENEMY_UNIT | Global.Collision.ENEMY_PROJ
	_atk_detect_box.collision_mask = Global.Collision.ENEMY_UNIT | Global.Collision.ENEMY_BASE
	_atk_dmg_box.collision_mask = Global.Collision.ENEMY_UNIT | Global.Collision.ENEMY_BASE
	global_position = Vector2(130, 530)

func _set_enemy() -> void:
	add_to_group("enemy_unit")
	_spawn.flip_h = true
	_dir = -1
	_hitbox.collision_layer = Global.Collision.ENEMY_UNIT
	_hitbox.collision_mask = Global.Collision.PLAYER_UNIT | Global.Collision.PLAYER_PROJ
	_atk_detect_box.collision_mask = Global.Collision.PLAYER_UNIT | Global.Collision.PLAYER_BASE
	_atk_dmg_box.collision_mask = Global.Collision.PLAYER_UNIT | Global.Collision.PLAYER_BASE
	global_position = Vector2(1000, 530)

func _resolve_attack() -> void:
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
	
	# Hit multiple enemies
	if _targets == -1:
		for target in valid_enemies:
			if is_instance_valid(target) and target._is_valid():
				_deal_dmg(target)
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
				_deal_dmg(target)
				targets_left -= 1
			idx += _dir

func _on_sprite_attack_frame_change() -> void:
	# Deal damage on a specific attack animation frame
	_atk_dmg_box.monitoring = true
	if _is_valid() and _sprite.animation == "attack" and _sprite.frame == _atk_frame:
		_resolve_attack()
		_atk_dmg_box.monitoring = false

###########################################################
