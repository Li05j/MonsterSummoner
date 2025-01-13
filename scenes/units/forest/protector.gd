class_name Protector extends MeleeTroops

# On death, instead of dying, change to form 2.
# Form 2 does not attack or move - it is purely a meat shield.
var _form_two = false

func _init_stats() -> void:
	_not_interactable = true
	_is_invincible = true
	
	_is_cc_immune = ForestUnits.protector_data.cc_immune
	_is_slow_immune = ForestUnits.protector_data.slow_immune
	
	_cost = ForestUnits.protector_data.cost
	_gold_drop = Global.get_gold_drop(_cost)
	_move_spd = ForestUnits.protector_data.move_spd
	_max_hp = ForestUnits.protector_data.max_hp
	_atk = ForestUnits.protector_data.atk
	_atk_spd = ForestUnits.protector_data.atk_spd
	_atk_frame = ForestUnits.protector_data.atk_frame
	
	_spwn_wait = ForestUnits.protector_data.spwn_wait
	
	_targets = ForestUnits.protector_data.targets
	
func _attack_special_effects(enemy) -> void:
	enemy.knockback(ForestUnits.protector_data.knockback_time)

func _change_to_form_two() -> void:
	_sprite.play("special")
	
	_form_two = true
	_sprite.frame_changed.disconnect(_on_sprite_attack_frame_change)
	_atk_detect_box.queue_free()
	_atk_dmg_box.queue_free()
	
	_is_cc_immune = true
	_is_slow_immune = true
	_move_spd = 0
	_attack_cd_timer.queue_free()
	_current_hp = _max_hp # restore back to full

func _move(delta: float) -> void:
	if _form_two:
		return
	super(delta)

func _dead() -> void:
	if !_form_two:
		_change_to_form_two()
		return
	if !_is_dead:
		super()
		EventBus.unit_died.emit(_who, _gold_drop)
		modulate.a = 0.7
		_hp_bar.modulate.a = 0.35
		#_hp_bar.visible = false
		_sprite.play("dead")
