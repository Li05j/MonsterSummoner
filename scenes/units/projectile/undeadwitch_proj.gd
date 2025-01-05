class_name UndeadWitchProj extends Projectile

@onready var _impact_box = _sprite.get_node("ImpactArea")

var _impact_success: bool = false
var _impact_frame = 3
var _impact_delay_timer: Timer
var _impact_delay: float = 0.25

func _ready() -> void:
	super()
	_offset_x = 37
	_offset_y = -77
	_travel_time = 1.5
	
func _init_collisions() -> void:
	super()
	_impact_box.collision_layer = Global.Collision.DETECT_ONLY

func _init_timers() -> void:
	super()
	_impact_delay_timer = _new_common_timer(_on_impact_delay_timeout, _impact_delay)

func _connect_signals() -> void:
	super()
	_sprite.animation_finished.connect(_on_sprite_animation_finished)
	_sprite.frame_changed.connect(_on_sprite_attack_frame_change)

func _move(delta: float) -> void:
	position += _v * delta
	if _affected_by_gravity and position.y <= _initial_position.y:
		_v.y += Global.gravity * delta
	if !_impact_success and abs(_initial_position.x - position.x) > _max_travel_dist:
		_dead()

func _set_initial_velocity() -> void:
	_linear()

func _resolve_contact(other: Area2D) -> void:
	if is_instance_valid(other):
		var enemy = other.get_parent().get_parent()
		if is_instance_valid(enemy) and enemy._is_valid():
			_proj_owner._deal_dmg(enemy)

func _resolve_attack() -> void:
	var valid_enemies = []
	for area in _impact_box.get_overlapping_areas():
		if !is_instance_valid(area):
			continue
			
		var enemy_node = area.get_parent().get_parent()
		if is_instance_valid(enemy_node):
			if enemy_node._is_valid():
				valid_enemies.append(enemy_node)
	
	if valid_enemies.size() == 0:
		return
	
	for target in valid_enemies:
		if is_instance_valid(target) and target._is_valid():
			_proj_owner._deal_dmg(target, 0.5)

func _on_hitbox_enter(other: Area2D) -> void:
	_impact_success = true
	_hitbox.monitoring = false
	_resolve_contact(other)
	_hitbox.monitoring = true
	_impact_delay_timer.start()

func _on_impact_delay_timeout() -> void:
	_hitbox.queue_free()
	_v = Vector2.ZERO
	_sprite.play("on_impact")

func _on_sprite_animation_finished() -> void:
	if _is_valid() and _sprite.animation == "on_impact":
		_dead()

func _on_sprite_attack_frame_change() -> void:
	# Deal damage on a specific attack animation frame
	_impact_box.monitoring = true
	if _is_valid() and _sprite.animation == "on_impact" and _sprite.frame == _impact_frame:
		_resolve_attack()
		_impact_box.monitoring = false

func init(proj_owner) -> void:
	super(proj_owner)
	if _proj_owner._who == Global.Who.ALLY:
		_impact_box.collision_mask = Global.Collision.ENEMY_UNIT | Global.Collision.ENEMY_BASE
	elif _proj_owner._who == Global.Who.ENEMY:
		_impact_box.collision_mask = Global.Collision.PLAYER_UNIT | Global.Collision.PLAYER_BASE
