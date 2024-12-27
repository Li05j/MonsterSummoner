class_name MeleeTroops extends BattleUnit

@onready var _spawn = $Spawn
@onready var _atk_detect_box = _sprite.get_node("AtkRangeBoxArea")
@onready var _atk_dmg_box = _sprite.get_node("AtkDmgBoxArea")

var _hp_bar_visible_timer: Timer
var _hp_bar_visible_timer_wait_time: int = 3

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
	if _not_interactable:
		return
		
	if !_is_dead:
		if global_position.y < Types.ground_y:
			_v_y += Types.gravity * delta
		else:
			_v_y = 0
			global_position.y = Types.ground_y
		_move(delta)

func _init_timers() -> void:
	super()
	add_spawn_timer()
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
	_atk_detect_box.body_entered.connect(_on_atk_detect_box_enter)
	_atk_detect_box.body_exited.connect(_on_atk_detect_box_exit)

func add_spawn_timer() -> void:
	var spawn_timer = Timer.new()
	spawn_timer.name = "spawn"
	spawn_timer.one_shot = true
	spawn_timer.timeout.connect(Callable(self, "_on_spawn_animation_done").bind(spawn_timer.name))
	add_child(spawn_timer)
	spawn_timer.start(_spwn_wait)

func _add_hp_bar_visible_timer() -> void:
	_hp_bar_visible_timer = Timer.new()
	_hp_bar_visible_timer.one_shot = true
	_hp_bar_visible_timer.wait_time = _hp_bar_visible_timer_wait_time
	_hp_bar_visible_timer.timeout.connect(_on_hp_bar_visible_timer_timeout)
	add_child(_hp_bar_visible_timer)

func _move(delta: float) -> void:
	position.x += _dir * _v_x * delta
	position.y += _v_y * delta

func _hurt_reaction() -> void:
	super()
	_hp_bar.visible = true
	_hp_bar_visible_timer.start()

func _dead() -> void:
	super()

func _on_spawn_animation_done(timer_name: String) -> void:
	_spawn.visible = false
	_sprite.visible = true
	if _who == Types.Who.ENEMY:
		_sprite.flip_h = true
	_sprite.play("run")
	_sprite.speed_scale = _spd_scale
	_v_x = _dir * _move_spd
	_not_interactable = false
	if get_node(timer_name) and is_instance_valid(get_node(timer_name)):
		get_node(timer_name).queue_free()
	_invincible_timer.start(0.75) # so unit wont get killed on spawn
	
	_atk_detect_box.monitoring = true

func _on_hitbox_enter() -> void:
	print("hitbox enter - does nothing")

func _on_hitbox_exit() -> void:
	print("hitbox exit")

func _on_atk_detect_box_enter() -> void:
	print("enemy detected")
	_v_x = 0

func _on_atk_detect_box_exit() -> void:
	print("enemy exited")

func _on_hp_bar_visible_timer_timeout() -> void:
	_hp_bar.visible = false

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
