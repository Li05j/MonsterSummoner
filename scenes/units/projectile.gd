class_name Projectile extends Unit

var _proj_owner

var _dir: int = 0
var _travel_time: float = 1.0 # 1 second
var _max_travel_dist: int
var _target_count: int
var _offset_y: int

var _initial_position: Vector2
var _v: Vector2

###########################################################

var _lock = false

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
	if position.y <= _initial_position.y:
		_v.y += Types.gravity * delta
	if abs(_initial_position.x - position.x) > _max_travel_dist:
		queue_free()

# set initial velocity
func _set_initial_velocity() -> void:
	pass

func _resolve_contact() -> void:
	pass

func attack_special_effects() -> void:
	pass

func _on_hitbox_enter(other: Area2D) -> void:
	_resolve_contact()

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
		#_sprite.scale.x *= -1

	global_position = Vector2(proj_owner.global_position.x, proj_owner.global_position.y + _offset_y)
	_initial_position = global_position
	_target_count = proj_owner._targets
	_max_travel_dist = proj_owner._proj_range

	_set_initial_velocity()

###########################################################
##### Movements #####
###########################################################

func _linear() -> void:
	_v = Vector2(_dir * _max_travel_dist / _travel_time, 0)

func _parabola() -> void:
	var vx: float = _dir * _max_travel_dist / _travel_time
	var vy: float = (-_offset_y - 0.5 * Types.gravity * _travel_time * _travel_time) / _travel_time
	_v = Vector2(vx, vy)
