class_name ShadowArcher extends ProjTroops

const _MULTISHOT_MAX: int = 3
var _multishot_counter: int = 0

func _init_stats() -> void:
	_not_interactable = true
	_is_invincible = true
	
	_is_cc_immune = DarknessUnits.shadowarcher_data.cc_immune
	_is_slow_immune = DarknessUnits.shadowarcher_data.slow_immune
	
	_cost = DarknessUnits.shadowarcher_data.cost
	_gold_drop = floor(_cost / 3.0)
	_move_spd = DarknessUnits.shadowarcher_data.move_spd
	_max_hp = DarknessUnits.shadowarcher_data.max_hp
	_atk = DarknessUnits.shadowarcher_data.atk
	_atk_spd = DarknessUnits.shadowarcher_data.atk_spd
	_atk_frame = DarknessUnits.shadowarcher_data.atk_frame
	
	_spwn_wait = DarknessUnits.shadowarcher_data.spwn_wait
	
	_targets = DarknessUnits.shadowarcher_data.targets
	
	#####
	_projectile_scene = preload(Paths.PROJ + "shadowarcher_proj.tscn")
	
func _init_proj_max_range() -> void:
	_max_travel_range = 1.3 * _atk_detect_box.get_child(0).shape.size.x * _sprite.scale.x
	_proj_range = _max_travel_range

func _resolve_attack() -> void:
	super()
	_new_temp_timer("multishot", "_on_multishot_timer_timeout", 0.1).start()

func _on_multishot_timer_timeout(timer_name: String) -> void:
	_multishot_counter += 1
	if _multishot_counter < _MULTISHOT_MAX and get_node(timer_name):
		_resolve_attack()
		get_node(timer_name).start()
	else:
		_multishot_counter = 0
		_free_temp_timer(timer_name)

func _attack_special_effects(enemy) -> void:
	var rand = randi_range(0, 4)
	if !rand:
		enemy.stun(0.75)
