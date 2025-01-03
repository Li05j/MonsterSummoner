class_name ShadowArcher extends ProjTroops

const _MULTISHOT_MAX: int = 3
var _multishot_counter: int = 0

func _ready() -> void:
	_not_interactable = true
	_is_invincible = true
	_is_cc_immune = false
	
	_cost = 40
	_gold_drop = floor(_cost / 3.0)
	_move_spd = 85
	_max_hp = 36
	_atk = 4
	_atk_spd = 1.8
	_atk_frame = 6
	
	_spwn_wait = 0.75
	
	_targets = 2
	
	#####
	
	_projectile_scene = preload(Paths.PROJ + "shadowarcher_proj.tscn")
	super()
	
func _init_proj_max_range() -> void:
	_max_travel_range = 1.3 * _atk_detect_box.get_child(0).shape.size.x * _sprite.scale.x
	_proj_range = _max_travel_range

func _resolve_attack() -> void:
	var projectile_instance: Projectile = _projectile_scene.instantiate()
	LevelState.current_level.add_child(projectile_instance)
	_set_proj_range()
	projectile_instance.init(self)
	
	var multishot_timer = _new_temp_timer("multishot", 0.1, "_on_multishot_timer_timeout")
	
	multishot_timer.start()

func _on_multishot_timer_timeout(timer_name: String) -> void:
	_multishot_counter += 1
	if _multishot_counter < _MULTISHOT_MAX and get_node(timer_name):
		_resolve_attack()
		get_node(timer_name).start()
	else:
		_multishot_counter = 0
		_free_timer(timer_name)
