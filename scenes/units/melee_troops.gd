class_name MeleeTroops extends BattleUnit

@onready var _spawn = $Spawn
@onready var _atk_detect_box = _sprite.get_node("AtkRangeBoxArea")
@onready var _atk_dmg_box = _sprite.get_node("AtkDmgBoxArea")

var _hp_bar_visible_timer: Timer
var _hp_bar_visible_timer_wait_time: int = 3

var _attack_cd_timer: Timer

##########################################################
##### States #####

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
		if global_position.y < Types.ground_y:
			_v_y += Types.gravity * delta
		else:
			_v_y = 0
			global_position.y = Types.ground_y
		_move(delta)

func _init_timers() -> void:
	super()
	_add_spawn_timer()
	_add_attack_cd_timer()
	_add_hp_bar_visible_timer()

func _init_collisions() -> void:
	_atk_detect_box.collision_layer = Types.Collision.DETECT_ONLY
	_atk_dmg_box.collision_layer = Types.Collision.DETECT_ONLY

func _init_misc() -> void:
	super()
	_sprite.visible = false
	_spawn.visible = true

func _connect_signals() -> void:
	super()
	_sprite.animation_finished.connect(_on_sprite_animation_finished)
	_sprite.frame_changed.connect(_on_sprite_attack_frame_change)
	
	_atk_detect_box.body_entered.connect(_on_atk_detect_box_enter)
	_atk_detect_box.body_exited.connect(_on_atk_detect_box_exit)

func _add_spawn_timer() -> void:
	var spawn_timer = Timer.new()
	spawn_timer.name = "spawn"
	spawn_timer.one_shot = true
	spawn_timer.timeout.connect(Callable(self, "_on_spawn_animation_done").bind(spawn_timer.name))
	add_child(spawn_timer)
	spawn_timer.start(_spwn_wait)

func _add_attack_cd_timer() -> void:
	_attack_cd_timer = Timer.new()
	_attack_cd_timer.wait_time = _atk_spd
	_attack_cd_timer.one_shot = true
	_attack_cd_timer.timeout.connect(_on_attack_cd_timer_timeout)
	add_child(_attack_cd_timer)

func _add_hp_bar_visible_timer() -> void:
	_hp_bar_visible_timer = Timer.new()
	_hp_bar_visible_timer.one_shot = true
	_hp_bar_visible_timer.wait_time = _hp_bar_visible_timer_wait_time
	_hp_bar_visible_timer.timeout.connect(_on_hp_bar_visible_timer_timeout)
	add_child(_hp_bar_visible_timer)

func _move(delta: float) -> void:
	if _cc_count == 0:
		if _if_any_enemy_in_range():
			_attack()
		else:
			position.x += _dir * _v_x * delta
			position.y += _v_y * delta

func _hurt_reaction() -> void:
	super()
	_hp_bar.visible = true
	_hp_bar_visible_timer.start()

func _dead() -> void:
	super()

func _if_any_enemy_in_range() -> bool:
	return _atk_detect_box.has_overlapping_areas()
	#var overlapping_areas = _atk_detect_box.get_overlapping_areas()
	#var valid_enemies = overlapping_areas.filter(
		#func(area):
			#if is_instance_valid(area):
				#return area.get_parent().get_parent()._is_valid() # so sus
			#)
	#if valid_enemies.size() > 0:
		#return true
	#else:
		#return false

func _attack() -> void:
	if _is_valid() and _cc_count == 0:
		_v_x = 0
		if _attack_cd_timer.is_stopped():
			_sprite.play("attack")

func _resolve_attack() -> void:
	var valid_enemies = []
	for area in _atk_detect_box.get_overlapping_areas():
		if !is_instance_valid(area):
			continue
			
		var enemy_node = area.get_parent().get_parent()
		if is_instance_valid(enemy_node):
			if enemy_node._is_valid():
				valid_enemies.append(enemy_node)
	
	if valid_enemies.size() == 0:
		return
		
	valid_enemies.sort_custom(
		func(a, b): 
			return a.global_position.x < b.global_position.x
	)
	
	var idx = 0
	var targets_left = _targets
	if _who == Types.Who.ENEMY:
		idx = valid_enemies.size() - 1
	
	while targets_left > 0:
		if idx < 0 or idx >= valid_enemies.size():
			break
		var target = valid_enemies[idx]
		if is_instance_valid(target):
			target.take_dmg(_atk)
		idx += _dir
		targets_left -= 1


func _on_spawn_animation_done(timer_name: String) -> void:
	_spawn.visible = false
	_sprite.visible = true
	_not_interactable = false
	
	if _who == Types.Who.ENEMY:
		_sprite.flip_h = true
		
	_sprite.play("run")
	_sprite.speed_scale = _spd_scale
	_v_x = _dir * _move_spd
	
	if get_node(timer_name) and is_instance_valid(get_node(timer_name)):
		get_node(timer_name).queue_free()
	_invincible_timer.start(0.75) # so unit wont get killed on spawn
	
	_atk_detect_box.monitoring = true

func _on_hitbox_enter(other: Area2D) -> void:
	print("hitbox enter - does nothing")

func _on_hitbox_exit(other: Area2D) -> void:
	print("hitbox exit")

func _on_atk_detect_box_enter(other: Area2D) -> void:
	pass

func _on_atk_detect_box_exit(other: Area2D) -> void:
	print("enemy exited")

func _on_attack_cd_timer_timeout() -> void:
	print("attack ready again")

func _on_hp_bar_visible_timer_timeout() -> void:
	_hp_bar.visible = false

func _on_sprite_animation_finished() -> void:
	if !_not_interactable and !_is_dead and _sprite.animation == "attack":
		_sprite.play("idle")  	# Idle while waiting for next attack
		_attack_cd_timer.start()	# Basic attack cooldown

func _on_sprite_attack_frame_change() -> void:
	# Deal damage on a specific attack animation frame
	if _is_valid() and _sprite.animation == "attack" and _sprite.frame == _atk_frame:
		_resolve_attack()

###########################################################

func _final_heal(amount: int) -> int:
	return amount

func _final_damage(damage: int) -> int:
	return damage

###########################################################

func set_who(who: Types.Who) -> void:
	_who = who
	if _who == Types.Who.ALLY:
		add_to_group("ally_unit")
		_spawn.flip_h = false
		_dir = 1
		_hitbox.collision_layer = Types.Collision.PLAYER_UNIT
		_hitbox.collision_mask = Types.Collision.ENEMY_UNIT | Types.Collision.ENEMY_PROJ
		_atk_detect_box.collision_mask = Types.Collision.ENEMY_UNIT | Types.Collision.ENEMY_BASE
		_atk_dmg_box.collision_mask = Types.Collision.ENEMY_UNIT | Types.Collision.ENEMY_BASE
		global_position = Vector2(130, 530)
	if _who == Types.Who.ENEMY:
		add_to_group("enemy_unit")
		_spawn.flip_h = true
		_dir = -1
		_hitbox.collision_layer = Types.Collision.ENEMY_UNIT
		_hitbox.collision_mask = Types.Collision.PLAYER_UNIT | Types.Collision.PLAYER_PROJ
		_atk_detect_box.collision_mask = Types.Collision.PLAYER_UNIT | Types.Collision.PLAYER_BASE
		_atk_dmg_box.collision_mask = Types.Collision.PLAYER_UNIT | Types.Collision.PLAYER_BASE
		global_position = Vector2(1000, 530)
