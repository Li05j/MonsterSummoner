class_name MeleeTroops extends BaseTroops

@onready var _atk_dmg_box = _sprite.get_node("AtkDmgBoxArea")

##########################################################
##### States #####

##### Stats #####

##### Others #####

###########################################################

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_init_stats()
	_init_timers()
	_init_collisions()
	_init_misc()
	_connect_signals()

func _set_ally() -> void:
	super()
	_atk_dmg_box.collision_mask = Global.Collision.ENEMY_UNIT | Global.Collision.ENEMY_BASE

func _set_enemy() -> void:
	super()
	_atk_dmg_box.collision_mask = Global.Collision.PLAYER_UNIT | Global.Collision.PLAYER_BASE

func _resolve_attack() -> void:
	var valid_enemies = _get_enemies_in_box(_atk_dmg_box)
	if valid_enemies.size() == 0:
		return
	
	# Hit multiple enemies
	if _targets == -1:
		for target in valid_enemies:
			if is_instance_valid(target) and target._is_valid():
				_deal_dmg(target)
	else:
		# sort from close to far first
		valid_enemies.sort_custom(
			func(a, b): 
				return a.global_position.x < b.global_position.x
				)
	
		var idx = 0
		var targets_left = _targets
		if _who == Global.Who.ENEMY:
			idx = valid_enemies.size() - 1
		var base = null
		while targets_left > 0 and idx >= 0 and idx < valid_enemies.size():
			var target = valid_enemies[idx]
			if is_instance_valid(target) and (target is AllyBase or target is EnemyBase):
				base = valid_enemies.pop_at(idx)
				if _who == Global.Who.ENEMY:
					idx += _dir
				continue
			if is_instance_valid(target) and target._is_valid():
				_deal_dmg(target)
				targets_left -= 1
			idx += _dir
		if targets_left:
			if is_instance_valid(base) and base._is_valid():
				_deal_dmg(base)

func _on_sprite_attack_frame_change() -> void:
	# Deal damage on a specific attack animation frame
	_atk_dmg_box.monitoring = true
	if _is_valid() and _sprite.animation == "attack" and _sprite.frame == _atk_frame:
		_resolve_attack()
		_atk_dmg_box.monitoring = false

###########################################################
