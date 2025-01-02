class_name ShadowArcher extends ProjTroops

func _ready() -> void:
	_not_interactable = true
	_is_invincible = true
	_is_cc_immune = false
	
	_cost = 40
	_gold_drop = floor(_cost / 3.0)
	_move_spd = 85
	_max_hp = 36
	_atk = 13
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
