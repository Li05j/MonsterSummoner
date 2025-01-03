class_name Projectile extends Unit

var _proj_owner: ProjTroops

var _dir: int = 0
var _travel_time: float = 1.0 # 1 second
var _max_travel_dist: int
var _max_target_count: int
var _offset_x: int = 0
var _offset_y: int = 0
var _affected_by_gravity: bool = false

var _curr_target_count: int = 0

var _initial_position: Vector2
var _v: Vector2

###########################################################

func _ready() -> void:
	_init_stats()
	_init_timers()
	_init_collisions()
	_init_misc()
	_connect_signals()

func _physics_process(delta: float) -> void:
	_move(delta)

func _move(delta: float) -> void:
	position += _v * delta
	if _affected_by_gravity and position.y <= _initial_position.y:
		_v.y += Types.gravity * delta
	if abs(_initial_position.x - position.x) > _max_travel_dist:
		_dead()

func _dead() -> void:
	if !_is_dead:
		_is_dead = true
		_proj_owner.proj_died()
	queue_free()

func _set_initial_velocity() -> void:
	pass

func _set_initial_pos() -> void:
	global_position = Vector2(
		_proj_owner.global_position.x + _offset_x * _dir, 
		_proj_owner.global_position.y + _offset_y
	)
	_initial_position = global_position

func _resolve_contact(other: Area2D) -> void:
	if is_instance_valid(other):
		var enemy = other.get_parent().get_parent()
		if is_instance_valid(enemy) and enemy._is_valid():
			_proj_owner._deal_dmg(enemy)
			
			if _max_target_count != -1:
				_curr_target_count += 1
				if _curr_target_count >= _max_target_count:
					_dead()

func _on_hitbox_enter(other: Area2D) -> void:
	_hitbox.monitoring = false
	# Hit multiple enemies
	if _max_target_count == -1 or _curr_target_count < _max_target_count:
		_resolve_contact(other)
	else:
		_dead()
	_hitbox.monitoring = true

#func _on_hitbox_exit(other: Area2D) -> void:
	#pass

func init(proj_owner) -> void:
	_proj_owner = proj_owner
	
	if _proj_owner._who == Types.Who.ALLY:
		_dir = 1
		_hitbox.collision_mask = Types.Collision.ENEMY_UNIT | Types.Collision.ENEMY_BASE
	else:
		_dir = -1
		scale.x *= -1
		_hitbox.collision_mask = Types.Collision.PLAYER_UNIT | Types.Collision.PLAYER_BASE

	_set_initial_pos()
	_max_target_count = proj_owner._targets
	_max_travel_dist = proj_owner._proj_range

	_set_initial_velocity()

###########################################################
##### Movements #####
###########################################################

func _stationary() -> void:
	_v = Vector2.ZERO

func _linear() -> void:
	_v = Vector2(_dir * _max_travel_dist / _travel_time, 0)

func _parabola() -> void:
	_affected_by_gravity = true
	var vx: float = _dir * _max_travel_dist / _travel_time
	var vy: float = (-_offset_y - 0.5 * Types.gravity * _travel_time * _travel_time) / _travel_time
	_v = Vector2(vx, vy)
