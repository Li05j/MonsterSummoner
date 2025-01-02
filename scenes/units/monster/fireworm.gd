class_name Fireworm extends ProjTroops

func _ready() -> void:
	_not_interactable = true
	_is_invincible = true
	_is_cc_immune = false
	
	_cost = 105
	_gold_drop = floor(_cost / 3.0)
	_move_spd = 85
	_max_hp = 145
	_atk = 11
	_atk_spd = 1.35
	_atk_frame = 10
	
	_spwn_wait = 1.5
	
	_targets = 3
	
	#####
	
	_projectile_scene = preload(Paths.PROJ + "fireworm_proj.tscn")
	super()
	
func _init_proj_max_range() -> void:
	_max_travel_range = 2 * _atk_detect_box.get_child(0).shape.size.x * _sprite.scale.x
	_proj_range = _max_travel_range
