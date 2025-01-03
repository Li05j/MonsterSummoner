class_name Iceworm extends ProjTroops

func _ready() -> void:
	_not_interactable = true
	_is_invincible = true
	_is_cc_immune = false
	_is_slow_immune = true
	
	_cost = 145
	_gold_drop = floor(_cost / 3.0)
	_move_spd = 80
	_max_hp = 165
	_atk = 10
	_atk_spd = 1.45
	_atk_frame = 10
	
	_spwn_wait = 1.5
	
	_targets = 4
	
	#####
	
	_projectile_scene = preload(Paths.PROJ + "iceworm_proj.tscn")
	super()
	
func _init_proj_max_range() -> void:
	_max_travel_range = 1.75 * _atk_detect_box.get_child(0).shape.size.x * _sprite.scale.x
	_proj_range = _max_travel_range

func _attack_special_effects(enemy) -> void:
	enemy.slow(1.5) # slow for 1.5 seconds
