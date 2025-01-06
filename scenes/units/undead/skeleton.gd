class_name Skeleton extends MeleeTroops

var _shield_timer: Timer
var _has_shielded: bool = false
const _shield_duration = 5.0 # seconds

func _init_stats() -> void:
	_not_interactable = true
	_is_invincible = true
	
	_is_cc_immune = UndeadUnits.skeleton_data.cc_immune
	_is_slow_immune = UndeadUnits.skeleton_data.slow_immune
	
	_cost = UndeadUnits.skeleton_data.cost
	_gold_drop = Global.get_gold_drop(_cost)
	_move_spd = UndeadUnits.skeleton_data.move_spd
	_max_hp = UndeadUnits.skeleton_data.max_hp
	_atk = UndeadUnits.skeleton_data.atk
	_atk_spd = UndeadUnits.skeleton_data.atk_spd
	_atk_frame = UndeadUnits.skeleton_data.atk_frame
	
	_spwn_wait = UndeadUnits.skeleton_data.spwn_wait
	
	_targets = UndeadUnits.skeleton_data.targets

func _init_timers() -> void:
	super()
	_shield_timer = _new_common_timer(_on_shield_timeout, _shield_duration)

#func _is_valid() -> bool:
	#return !(_not_interactable or _is_dead or _during_special)

func _hurt_reaction() -> void:
	super()
	if !_has_shielded and !_cc_count and get_hp_percent() <= 0.33:
		_shield()
	if _during_special:
		_v_x = 0
		_sprite.play("special")

func _shield() -> void:
	_has_shielded = true
	if _shield_timer.is_stopped():
		_during_special = true
		_is_cc_immune = true
		
		_def += UndeadUnits.skeleton_data.increased_def
		_attack_cd_timer.start(5.0)
		_shield_timer.start()

func _on_shield_timeout() -> void:
	_during_special = false
	_is_cc_immune = false
	_def -= UndeadUnits.skeleton_data.increased_def

func _on_sprite_animation_finished() -> void:
	super()
	if _sprite.animation == "special":
		_v_x = _dir * _move_spd
