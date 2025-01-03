class_name Slime extends ProjTroops

func _ready() -> void:
	_not_interactable = true
	_is_invincible = true
	_is_cc_immune = false
	
	_cost = 60
	_gold_drop = floor(_cost / 3.0)
	_move_spd = 60
	_max_hp = 43
	_atk = 34
	_atk_spd = 2.4
	_atk_frame = 3
	
	_spwn_wait = 0.75
	
	_targets = 1
	
	#####
	
	_projectile_scene = preload(Paths.PROJ + "slime_proj.tscn")
	super()

func _set_proj_range() -> void:
	_by_closest_target()
