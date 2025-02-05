class_name King extends MeleeTroops

# Heal all allies on spawn

var _atk_frame1
var _atk_frame2

var _enlarged: bool = false

func _init_stats() -> void:
	_not_interactable = true
	_is_invincible = true
	
	_is_cc_immune = HumanUnits.king_data.cc_immune
	_is_slow_immune = HumanUnits.king_data.slow_immune
	
	_cost = HumanUnits.king_data.cost
	_gold_drop = Global.get_gold_drop(_cost)
	_move_spd = HumanUnits.king_data.move_spd
	_max_hp = HumanUnits.king_data.max_hp
	_atk = HumanUnits.king_data.atk
	_atk_spd = HumanUnits.king_data.atk_spd
	
	_atk_frame1 = HumanUnits.king_data.atk_frame1
	_atk_frame2 = HumanUnits.king_data.atk_frame2
	
	_spwn_wait = HumanUnits.king_data.spwn_wait
	
	_targets = HumanUnits.king_data.targets

func _hurt_reaction() -> void:
	super()
	if !_enlarged and get_hp_percent() <= HumanUnits.king_data.threshold:
		_enlarge()

func _enlarge() -> void:
	_sprite.scale *= 2.0
	_enlarged = true

func _on_spawn_animation_done(timer_name: String) -> void:
	super(timer_name)
	var allies
	if _who == Global.Who.ALLY:
		allies = get_tree().get_nodes_in_group("ally_unit")
	elif _who == Global.Who.ENEMY:
		allies = get_tree().get_nodes_in_group("enemy_unit")
	if allies.size() == 0:
		return
	for target in allies:
		if is_instance_valid(target) and target._is_valid():
			target.heal(HumanUnits.king_data.heal_amount)
