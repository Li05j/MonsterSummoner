class_name Reaper extends MeleeTroops

const _summon_count: int = 3
const _skull_animation_scene = preload(Paths.ANIMATIONS + "skull_animation.tscn")
const _bat_scene = preload(Paths.UNDEAD + "bat.tscn")

const _skull_y_offset = -120

var _original_scale

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

func _init_misc() -> void:
	super()
	_original_scale = _sprite.scale

func _resolve_attack() -> void:
	var valid_enemies = _get_enemies_in_box(_atk_dmg_box)
	
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

func _add_cc(cc: bool) -> void:
	if cc:
		_cc_count += 1
		_attack_cd_timer.set_paused(true)
		_sprite.play("idle")
		if _sprite.scale > _original_scale:
			_sprite.scale /= 1.5
	if !cc:
		_cc_count -= 1
		if _cc_count == 0:
			_attack_cd_timer.set_paused(false)

func _on_kill_special_effects(enemy) -> void:
	if enemy is not BaseTroops or enemy.a_summon:
		return
	var skull = _skull_animation_scene.instantiate()
	skull.global_position = Vector2(enemy.global_position.x, enemy.global_position.y + _skull_y_offset)
	LevelState.current_level.add_child(skull)
	
	var bat = _bat_scene.instantiate()
	LevelState.current_level.add_child(bat)
	bat.set_who(_who)
	# overwrite position
	bat.global_position = Vector2(enemy.global_position.x, enemy.global_position.y)
	
	var current_count = 1
	while current_count < _summon_count:
		bat = _bat_scene.instantiate()
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
