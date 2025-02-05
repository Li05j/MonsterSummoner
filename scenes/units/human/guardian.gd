class_name Guardian extends MeleeTroops

# Dashes to backline once
@onready var _special_detect_area = _sprite.get_node("SpecialDetectArea")
@onready var _special_dmg_area = _sprite.get_node("SpecialDamageArea")

var _dashed: bool = false
var _dash_coord_x: int
const _dash_frame = 5
const _sp_dmg_frame = 12

var _atk_frame1
var _atk_frame2
var _atk_frame3
var _atk_frame4

func _init_stats() -> void:
	_not_interactable = true
	_is_invincible = true
	
	_is_cc_immune = HumanUnits.guardian_data.cc_immune
	_is_slow_immune = HumanUnits.guardian_data.slow_immune
	
	_cost = HumanUnits.guardian_data.cost
	_gold_drop = Global.get_gold_drop(_cost)
	_move_spd = HumanUnits.guardian_data.move_spd
	_max_hp = HumanUnits.guardian_data.max_hp
	_atk = HumanUnits.guardian_data.atk
	_atk_spd = HumanUnits.guardian_data.atk_spd
	
	_atk_frame1 = HumanUnits.guardian_data.atk_frame1
	_atk_frame2 = HumanUnits.guardian_data.atk_frame2
	_atk_frame3 = HumanUnits.guardian_data.atk_frame3
	_atk_frame4 = HumanUnits.guardian_data.atk_frame4
	
	_spwn_wait = HumanUnits.guardian_data.spwn_wait
	
	_targets = HumanUnits.guardian_data.targets

func _init_collisions() -> void:
	super()
	_special_detect_area.collision_layer = Global.Collision.DETECT_ONLY
	_special_dmg_area.collision_layer = Global.Collision.DETECT_ONLY

func _set_ally() -> void:
	_special_detect_area.collision_mask = Global.Collision.ENEMY_UNIT | Global.Collision.ENEMY_BASE
	_special_dmg_area.collision_mask = Global.Collision.ENEMY_UNIT | Global.Collision.ENEMY_BASE
	super()

func _set_enemy() -> void:
	_special_detect_area.collision_mask = Global.Collision.PLAYER_UNIT | Global.Collision.PLAYER_BASE
	_special_dmg_area.collision_mask = Global.Collision.PLAYER_UNIT | Global.Collision.PLAYER_BASE
	super()

func _is_valid() -> bool:
	return !(_not_interactable or _is_dead or _during_special)

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

func _attack() -> void:
	if !_dashed:
		_dash()
	elif _is_valid() and _cc_count == 0:
		_v_x = 0
		if _attack_cd_timer.is_stopped():
			_sprite.play("attack")

func _dash() -> void:
	_during_special = true
	var valid_enemies = _get_enemies_in_box(_special_detect_area)
	if valid_enemies.size() == 0:
		return
	_dash_coord_x = global_position.x
	for target in valid_enemies:
		if is_instance_valid(target) and target._is_valid():
			if _who == Global.Who.ALLY and target.global_position.x > _dash_coord_x:
				_dash_coord_x = target.global_position.x
			elif _who == Global.Who.ENEMY and target.global_position.x < _dash_coord_x:
				_dash_coord_x = target.global_position.x
	if _dash_coord_x < LevelState.ally_base_pos.x + Global.summon_offset_x * 2:
		_dash_coord_x = LevelState.ally_base_pos.x + Global.summon_offset_x * 2
	elif _dash_coord_x > LevelState.enemy_base_pos.x - Global.summon_offset_x * 2:
		_dash_coord_x = LevelState.enemy_base_pos.x - Global.summon_offset_x * 2
	_sprite.play("special")

func _on_sprite_animation_finished() -> void:
	super()
	if _sprite.animation == "special":
		_v_x = _dir * _move_spd
		_dashed = true
		_during_special = false
		_special_detect_area.monitoring = false
		_special_detect_area.monitorable = false
		_special_dmg_area.monitoring = false
		_special_dmg_area.monitorable = false

func _on_sprite_attack_frame_change() -> void:
	# Deal damage on a specific attack animation frame
	_atk_dmg_box.monitoring = true
	if _is_valid() and _sprite.animation == "attack":
		if _sprite.frame == _atk_frame1 or _sprite.frame == _atk_frame2 or _sprite.frame == _atk_frame3 or _sprite.frame == _atk_frame4:
			_resolve_attack()
			_atk_dmg_box.monitoring = false
			
	if _sprite.animation == "special":
		if _sprite.frame == _dash_frame:
			global_position.x = _dash_coord_x
		elif _sprite.frame == _sp_dmg_frame:
			var valid_enemies = _get_enemies_in_box(_special_dmg_area)
			if valid_enemies.size() == 0:
				return
	
			# Hit all enemies
			for target in valid_enemies:
				if is_instance_valid(target) and target._is_valid():
					target.stun(HumanUnits.guardian_data.stun_time)
					_deal_dmg(target)
