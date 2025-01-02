class_name Projectile extends Unit

var _proj_owner

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
	queue_free()

# set initial velocity
func _set_initial_velocity() -> void:
	pass

func _resolve_contact(other: Area2D) -> void:
	if is_instance_valid(other):
		var enemy = other.get_parent().get_parent()
		if is_instance_valid(enemy) and enemy._is_valid():
			_proj_owner._deal_dmg(enemy)
			
			_curr_target_count += 1
			if _curr_target_count >= _max_target_count || _max_target_count == 0:
				_dead()

func attack_special_effects(other) -> void:
	pass

func _on_hitbox_enter(other: Area2D) -> void:
	_hitbox.monitoring = false
	if _curr_target_count < _max_target_count:
		_resolve_contact(other)
	else:
		_dead()
	_hitbox.monitoring = true

func _on_hitbox_exit(other: Area2D) -> void:
	pass

func init(proj_owner) -> void:
	_proj_owner = proj_owner
	
	if proj_owner._who == Types.Who.ALLY:
		_dir = 1
		_hitbox.collision_mask = Types.Collision.ENEMY_UNIT | Types.Collision.ENEMY_BASE
	else:
		_dir = -1
		_hitbox.collision_mask = Types.Collision.PLAYER_UNIT | Types.Collision.PLAYER_BASE

	global_position = Vector2(
		proj_owner.global_position.x + _offset_x * _dir, 
		proj_owner.global_position.y + _offset_y
	)
	_initial_position = global_position
	_max_target_count = proj_owner._targets
	_max_travel_dist = proj_owner._proj_range

	_set_initial_velocity()

###########################################################
##### Movements #####
###########################################################

func _linear() -> void:
	_v = Vector2(_dir * _max_travel_dist / _travel_time, 0)

func _parabola() -> void:
	_affected_by_gravity = true
	var vx: float = _dir * _max_travel_dist / _travel_time
	var vy: float = (-_offset_y - 0.5 * Types.gravity * _travel_time * _travel_time) / _travel_time
	_v = Vector2(vx, vy)
