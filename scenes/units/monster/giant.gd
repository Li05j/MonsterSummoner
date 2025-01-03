class_name Giant extends MeleeTroops

# Knockbacks on hit, AOE, takes 3 less dmg from all sources

func _ready() -> void:
	_not_interactable = true
	_is_invincible = true
	_is_cc_immune = true
	
	_cost = 265
	_gold_drop = floor(_cost / 3.0)
	_move_spd = 35
	_max_hp = 1500
	_atk = 12
	_atk_spd = 4.5
	_atk_frame = 3
	
	_spwn_wait = 3.0
	
	_targets = -1
	super()
	
func _attack_special_effects(enemy) -> void:
	var knockback_duration = 1.5 # seconds
	if enemy is BaseTroops:
		enemy.knockback(knockback_duration)

func _final_damage(damage: int) -> int:
	return max(0, damage - 3)
