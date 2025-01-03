class_name Goblin extends MeleeTroops

func _ready() -> void:
	_not_interactable = true
	_is_invincible = true
	_is_cc_immune = false
	_is_slow_immune = false
	
	_cost = 40
	_gold_drop = floor(_cost / 3.0)
	_move_spd = 130
	_max_hp = 91
	_atk = 8
	_atk_spd = 0.4
	_atk_frame = 6
	
	_spwn_wait = 0.75
	
	_targets = 1
	
	var rand = randi_range(0, 4)
	if !rand:	# 1 in 4 it summons big goblin
		_max_hp *= 1.2
		_atk *= 1.2
		_sprite.scale *= 1.4
		_hp_bar.position.y = -150
	super()
