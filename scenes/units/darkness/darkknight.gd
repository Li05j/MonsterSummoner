class_name DarkKnight extends MeleeTroops

var _berserk_timer: Timer
var _has_gone_berserk = false
const _berserk_duration = 4.0 # seconds

func _init_stats() -> void:
	_not_interactable = true
	_is_invincible = true
	
	_is_cc_immune = DarknessUnits.darkknight_data.cc_immune
	_is_slow_immune = DarknessUnits.darkknight_data.slow_immune
	
	_cost = DarknessUnits.darkknight_data.cost
	_gold_drop = floor(_cost / 3.0)
	_move_spd = DarknessUnits.darkknight_data.move_spd
	_max_hp = DarknessUnits.darkknight_data.max_hp
	_atk = DarknessUnits.darkknight_data.atk
	_atk_spd = DarknessUnits.darkknight_data.atk_spd
	_atk_frame = DarknessUnits.darkknight_data.atk_frame
	
	_spwn_wait = DarknessUnits.darkknight_data.spwn_wait
	
	_targets = DarknessUnits.darkknight_data.targets

func _init_timers() -> void:
	super()
	_berserk_timer = _new_common_timer(_on_berserk_timeout, _berserk_duration)

func _hurt_reaction() -> void:
	super()
	if !_has_gone_berserk and get_hp_percent() <= 0.25:
		_berserk()

func _berserk() -> void:
	_has_gone_berserk = true
	if _berserk_timer.is_stopped():
		# immune to slow and shed slow effect
		_is_slow_immune = true
		if _is_slowed:
			var slow_timer: Timer = get_node("slow_timer")
			if is_instance_valid(slow_timer):
				slow_timer.stop()
				_on_slow_timeout("slow_timer")
		
		_atk_spd = 0.1
		_attack_cd_timer.wait_time = _atk_spd
		
		_modify_spd_scale(2.0, false)
		
		_sprite.self_modulate = _sprite.self_modulate.lerp(Color(1, 0, 0), 0.5)
		if !_attack_cd_timer.is_stopped():
			_attack_cd_timer.stop()
		_berserk_timer.start()

func _on_berserk_timeout() -> void:
	_is_slow_immune = false
	
	_atk_spd = 4.2
	_attack_cd_timer.wait_time = _atk_spd
	
	_modify_spd_scale(2.0, true)
	
	_sprite.self_modulate = Color(1, 1, 1, 1)
