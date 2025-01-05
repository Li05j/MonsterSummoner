class_name Reaper extends MeleeTroops

const _summon_count: int = 3
const skull_animation_scene = preload(Paths.ANIMATIONS + "skull_animation.tscn")
const bat_scene = preload(Paths.UNDEAD + "bat.tscn")

const skull_y_offset = -120

func _init_stats() -> void:
	_not_interactable = true
	_is_invincible = true
	
	_is_cc_immune = UndeadUnits.reaper_data.cc_immune
	_is_slow_immune = UndeadUnits.reaper_data.slow_immune
	
	_cost = UndeadUnits.reaper_data.cost
	_gold_drop = Global.get_gold_drop(_cost)
	_move_spd = UndeadUnits.reaper_data.move_spd
	_max_hp = UndeadUnits.reaper_data.max_hp
	_atk = UndeadUnits.reaper_data.atk
	_atk_spd = UndeadUnits.reaper_data.atk_spd
	_atk_frame = UndeadUnits.reaper_data.atk_frame
	
	_spwn_wait = UndeadUnits.reaper_data.spwn_wait
	
	_targets = UndeadUnits.reaper_data.targets

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
		
	valid_enemies.sort_custom(
		func(a, b): 
			return a.global_position.x < b.global_position.x
			)
	var idx = 0
	if _who == Global.Who.ENEMY:
		idx = valid_enemies.size() - 1
	
	# 1st target takes 2x damage
	var target = valid_enemies[idx]
	if is_instance_valid(target) and target._is_valid():
		_deal_dmg(target, 2.0, 0, self)
	idx += _dir
	
	while idx >= 0 and idx < valid_enemies.size():
		target = valid_enemies[idx]
		if is_instance_valid(target) and target._is_valid():
			_deal_dmg(target, 1.0, 0, self)
		idx += _dir

func _attack_special_effects(enemy) -> void:
	if enemy._is_valid() and enemy is BaseTroops and !enemy.a_summon and enemy.get_hp_percent() <= 0.1:
		enemy._take_dmg(enemy._max_hp)
		_on_kill_special_effects(enemy)

func _on_kill_special_effects(enemy) -> void:
	if enemy is not BaseTroops or enemy.a_summon:
		return
	var skull = skull_animation_scene.instantiate()
	skull.global_position = Vector2(enemy.global_position.x, enemy.global_position.y + skull_y_offset)
	LevelState.current_level.add_child(skull)
	
	var bat = bat_scene.instantiate()
	LevelState.current_level.add_child(bat)
	bat.set_who(_who)
	# overwrite position
	bat.global_position = Vector2(enemy.global_position.x, enemy.global_position.y)
	
	var current_count = 1
	while current_count < _summon_count:
		bat = bat_scene.instantiate()
		var min = -60
		var max = 60
		if _who == Global.Who.ALLY:
			min *= 4
		elif _who == Global.Who.ENEMY:
			max *= 4
		var flux = randf_range(min, max)
		LevelState.current_level.add_child(bat)
		bat.set_who(_who)
		
		bat.global_position = Vector2(enemy.global_position.x + flux, enemy.global_position.y)
		current_count += 1

func _on_sprite_attack_frame_change() -> void:
	# Deal damage on a specific attack animation frame
	_atk_dmg_box.monitoring = true
	if _is_valid() and _sprite.animation == "attack" and _sprite.frame == _atk_frame:
		_sprite.scale *= 1.5
		_resolve_attack()
		_atk_dmg_box.monitoring = false
	if _is_valid() and _sprite.animation == "attack" and _sprite.frame == _atk_frame + 2:
		_sprite.scale /= 1.5
