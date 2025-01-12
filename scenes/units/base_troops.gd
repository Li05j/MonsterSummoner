class_name BaseTroops extends BattleUnit

@onready var _spawn = $SpawnAnimation
@onready var _atk_detect_box = _sprite.get_node("AtkDetectBoxArea")

var a_summon = false

##########################################################

var _hp_bar_visible_timer: Timer
var _attack_cd_timer: Timer

##########################################################
##### States #####

var _during_special: bool = false

##### Stats #####

var _cost: int = 0
var _gold_drop: int = 0 # floor(_cost / 3.0)
var _move_spd: int = 1
var _atk: int = 0
var _atk_spd: float = 1.0
var _atk_frame: int = 0 # the frame the atk is resolved
var _spwn_wait: float = 1.0 # spanw waiting time
var _spd_scale: float = 1.0 # animation rate, low means slow
var _targets: int = 1 # how many targets, -1 means all in range, else closest first
var _cc_rate: float = 1.0 # cc effectiveness, when 0 then it is equal to immune

var _def: int = 0
var _atk_rate: float = 1.0

##### All CC Variables #####

var _is_knockback: bool = false
var _is_slowed: bool = false
var _is_stunned: bool = false
var _is_feared: bool = false

##### Others #####

var _dir: int = 1 # direction
var _v_x: float = 0
var _v_y: float = 0

var _description: String = "Meow"

###########################################################

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_init_stats()
	_init_timers()
	_init_collisions()
	_init_misc()
	_connect_signals()

func _physics_process(delta: float) -> void:
	if _is_valid():
		if global_position.y < Global.ground_y:
			_v_y += Global.gravity * delta
		else:
			#_v_y = 0
			global_position.y = Global.ground_y
		_move(delta)

func _init_timers() -> void:
	super()
	_new_temp_timer("spawn", "_on_spawn_animation_done", _spwn_wait).start()
	_attack_cd_timer = _new_common_timer(_on_attack_cd_timer_timeout, _atk_spd)
	_hp_bar_visible_timer = _new_common_timer(_on_hp_bar_visible_timer_timeout, Global.hp_bar_visible_time)

func _init_collisions() -> void:
	super()
	_atk_detect_box.collision_layer = Global.Collision.DETECT_ONLY

func _init_misc() -> void:
	super()
	_sprite.visible = false
	_spawn.visible = true

func _connect_signals() -> void:
	super()
	_sprite.animation_finished.connect(_on_sprite_animation_finished)
	_sprite.frame_changed.connect(_on_sprite_attack_frame_change)
	
	#_atk_detect_box.area_entered.connect(_on_atk_detect_box_enter)
	#_atk_detect_box.area_exited.connect(_on_atk_detect_box_exit)

func _move(delta: float) -> void:
	if _cc_count == 0:
		if _if_any_enemy_in_range():
			_attack()
		elif _sprite.animation != "attack":
			_sprite.play("run")
			_v_x = _dir * _move_spd
			
	position.x += _v_x * _spd_scale * delta
	position.y += _v_y * delta
	
	if _v_x == 0 and _sprite.animation == "run":
		_sprite.play("idle")

func _set_ally() -> void:
	add_to_group("ally_unit")
	_spawn.flip_h = false
	_dir = 1
	_hitbox.collision_layer = Global.Collision.PLAYER_UNIT
	_hitbox.collision_mask = Global.Collision.ENEMY_UNIT | Global.Collision.ENEMY_PROJ
	_atk_detect_box.collision_mask = Global.Collision.ENEMY_UNIT | Global.Collision.ENEMY_BASE
	global_position = Vector2(LevelState.ally_base_pos.x + Global.summon_offset_x, LevelState.ally_base_pos.y)

func _set_enemy() -> void:
	add_to_group("enemy_unit")
	_spawn.flip_h = true
	_dir = -1
	_hitbox.collision_layer = Global.Collision.ENEMY_UNIT
	_hitbox.collision_mask = Global.Collision.PLAYER_UNIT | Global.Collision.PLAYER_PROJ
	_atk_detect_box.collision_mask = Global.Collision.PLAYER_UNIT | Global.Collision.PLAYER_BASE
	global_position = Vector2(LevelState.enemy_base_pos.x - Global.summon_offset_x, LevelState.enemy_base_pos.y)

func _hurt_reaction() -> void:
	super()
	_hp_bar.visible = true
	_hp_bar_visible_timer.start()

func _dead() -> void:
	if !_is_dead:
		super()
		EventBus.unit_died.emit(_who, _gold_drop)
		modulate.a = 0.7
		_hp_bar.modulate.a = 0.35
		#_hp_bar.visible = false
		_sprite.play("dead")

#func _gain_gold_on_death() -> void:
	#if _who == Global.Who.ALLY:
		#LevelState.enemy_ai.enemy_gold += _gold_drop
	#if _who == Global.Who.ENEMY:
		#LevelState.player_gold += _gold_drop
	
func _if_any_enemy_in_range() -> bool:
	var count = 0
	for area in _atk_detect_box.get_overlapping_areas():
		if !is_instance_valid(area):
			continue
			
		var enemy_node = area.get_parent().get_parent()
		if is_instance_valid(enemy_node):
			if enemy_node._is_valid():
				count += 1
	return count

func _attack() -> void:
	if _is_valid() and _cc_count == 0:
		_v_x = 0
		if _attack_cd_timer.is_stopped():
			_sprite.play("attack")

func _resolve_attack() -> void:
	pass

func _deal_dmg(enemy, modifier: float = 1.0, flat_dmg: int = 0, killer = null) -> void:
	var kill: bool = enemy._take_dmg(_get_final_atk() * modifier + flat_dmg)
	_attack_special_effects(enemy)
	if kill and killer:
		killer._on_kill_special_effects(enemy)

func _attack_special_effects(enemy) -> void:
	pass

func _on_kill_special_effects(enemy) -> void:
	pass

func _counter(other) -> void:
	if is_instance_valid(other) and other is not Projectile:
		_deal_dmg(other)

# if rate = -1 it resets - there is no reason for spd scale to be negative
func _modify_spd_scale(rate: float, revert: bool) -> void:
	if rate == -1:
		_spd_scale = 1.0
	elif revert == false:
		_spd_scale *= rate
	else:
		_spd_scale /= rate
	_sprite.speed_scale = _spd_scale

func _on_spawn_animation_done(timer_name: String) -> void:
	_atk_detect_box.monitoring = true
	_spawn.visible = false
	_sprite.visible = true
	_not_interactable = false
	
	if _who == Global.Who.ENEMY:
		_sprite.scale.x *= -1
		
	_sprite.play("run")
	_sprite.speed_scale = _spd_scale
	_v_x = _dir * _move_spd
	
	if get_node(timer_name) and is_instance_valid(get_node(timer_name)):
		get_node(timer_name).queue_free()
		
	_invincible_timer.start(Global.on_spawn_i_frame) # so unit wont get killed on spawn

#func _on_hitbox_enter(other: Area2D) -> void:
	#print("hitbox enter - does nothing")
#
#func _on_hitbox_exit(other: Area2D) -> void:
	#print("hitbox exit")
#
#func _on_atk_detect_box_enter(other: Area2D) -> void:
	#pass
#
#func _on_atk_detect_box_exit(other: Area2D) -> void:
	#print("enemy exited")

func _on_attack_cd_timer_timeout() -> void:
	pass

func _on_hp_bar_visible_timer_timeout() -> void:
	_hp_bar.visible = false

func _on_sprite_animation_finished() -> void:
	if _is_valid() and _sprite.animation == "attack":
		_sprite.play("idle")  	# Idle while waiting for next attack
		_attack_cd_timer.start()	# Basic attack cooldown
	if _sprite.animation == "dead":
		self.queue_free()

func _on_sprite_attack_frame_change() -> void:
	# Deal damage on a specific attack animation frame
	if _is_valid() and _sprite.animation == "attack" and _sprite.frame == _atk_frame:
		_resolve_attack()

##########################################################
##### Stat getters #####
##########################################################

func _final_damage(damage: int) -> int:
	return max(1, (damage - _def) * _dmg_rate)

func _get_final_atk() -> int:
	return floor(_atk * _atk_rate)

##########################################################
##### All CC interactions #####
##########################################################

func slow(duration: float) -> void:
	if !_is_valid() or _is_slow_immune:
		return
	if _is_slowed: # if alreay slowed refresh slow duration instead
		var slow_timer: Timer = get_node("slow_timer")
		if is_instance_valid(slow_timer):
			slow_timer.start() # restart
		return
	
	_is_slowed = true
	
	var actual_duration = duration * _cc_rate
	_modify_spd_scale(0.6, false)
	_apply_tint("slow", Color(0, 0, 1))
	
	_new_temp_timer("slow_timer", "_on_slow_timeout", actual_duration).start()

func knockback(duration: float) -> void:
	if !_is_valid() or _is_cc_immune:
		return
	if _is_knockback: # do not knockback again
		return
	
	_add_cc(true)
	_is_knockback = true
	
	var actual_duration = duration * _cc_rate
	var fluc_x = randf_range(0, 0.5) # 1.0 - 1.5 movespd knockback
	_v_x = -_dir * _move_spd + _move_spd * fluc_x
	_v_y = -Global.gravity * (actual_duration / 2)
	
	_new_temp_timer("knockback_timer", "_on_cc_timeout", actual_duration).start()

func stun(duration: float) -> void:
	if !_is_valid() or _is_cc_immune:
		return
	if _is_stunned: # do not stun again
		return
	
	_add_cc(true)
	_is_stunned = true
	
	var actual_duration = duration * _cc_rate
	_v_x = 0
	
	_new_temp_timer("stun_timer", "_on_cc_timeout", actual_duration).start()

func fear(duration: float) -> void:
	if !_is_valid() or _is_cc_immune:
		return
	if _is_feared: # do not fear again
		return
	
	_add_cc(true)
	_is_feared = true
	
	var actual_duration = duration * _cc_rate
	var fluc_x = randf_range(0.9, 1.1)
	_v_x = -1 * _dir * _move_spd * fluc_x
	_sprite.scale.x *= -1
	_apply_tint("fear", Color(1, 0, 1))
	_sprite.play("run")
	
	_new_temp_timer("fear_timer", "_on_cc_timeout", actual_duration).start()

# When unit is cc'd or free of cc
func _add_cc(cc: bool) -> void:
	if cc:
		_cc_count += 1
		_attack_cd_timer.set_paused(true)
		_sprite.play("idle")
	if !cc:
		_cc_count -= 1
		if _cc_count == 0:
			_attack_cd_timer.set_paused(false)

func _on_cc_timeout(timer_name: String) -> void:
	match timer_name:
		"knockback_timer":
			_is_knockback = false
		"stun_timer":
			_is_stunned = false
		"fear_timer":
			_is_feared = false
			_sprite.scale.x *= -1
			_sprite.self_modulate = Color(1, 1, 1, 1)
		_:
			return
	_add_cc(false)
	_free_temp_timer(timer_name)

func _on_slow_timeout(timer_name: String) -> void:
	_is_slowed = false
	_modify_spd_scale(0.6, true)
	_remove_tint("slow")
	_free_temp_timer(timer_name)

###########################################################

func set_who(who: Global.Who) -> void:
	_who = who
	if _who == Global.Who.ALLY:
		_set_ally()
	if _who == Global.Who.ENEMY:
		_set_enemy()
