class_name Goblin extends MeleeTroops

func _ready() -> void:
	_not_interactable = true
	_is_invincible = true
	_is_cc_immune = false
	
	_cost = 40
	_gold_drop = floor(_cost / 3.0)
	_move_spd = 400
	_max_hp = 88
	_atk = 9
	_atk_spd = 0.4
	_atk_frame = 6
	
	_spwn_wait = 0.75
	_spd_scale = 1.0
	
	_targets = 1
	super()
