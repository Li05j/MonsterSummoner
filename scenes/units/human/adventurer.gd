class_name Adventurer extends MeleeTroops

var _atk_frame1
var _atk_frame2
var _atk_frame3

func _init_stats() -> void:
	_not_interactable = true
	_is_invincible = true
	
	_is_cc_immune = HumanUnits.adventurer_data.cc_immune
	_is_slow_immune = HumanUnits.adventurer_data.slow_immune
	
	_cost = HumanUnits.adventurer_data.cost
	_gold_drop = Global.get_gold_drop(_cost)
	_move_spd = HumanUnits.adventurer_data.move_spd
	_max_hp = HumanUnits.adventurer_data.max_hp
	_atk = HumanUnits.adventurer_data.atk
	_atk_spd = HumanUnits.adventurer_data.atk_spd
	
	_atk_frame1 = HumanUnits.adventurer_data.atk_frame1
	_atk_frame2 = HumanUnits.adventurer_data.atk_frame2
	_atk_frame3 = HumanUnits.adventurer_data.atk_frame3
	
	_spwn_wait = HumanUnits.adventurer_data.spwn_wait
	
	_targets = HumanUnits.adventurer_data.targets

func _on_sprite_attack_frame_change() -> void:
	# Deal damage on a specific attack animation frame
	_atk_dmg_box.monitoring = true
	if _is_valid() and _sprite.animation == "attack":
		if _sprite.frame == _atk_frame1 or _sprite.frame == _atk_frame2 or _sprite.frame == _atk_frame3:
			_resolve_attack()
			_atk_dmg_box.monitoring = false
