class_name Unit extends Node2D

@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _hitbox: Area2D = _sprite.get_node("HitboxArea")

var _dead_timer: Timer
var _invincible_timer: Timer

var _who: Types.Who = Types.Who.NONE

##########################################################
##### States #####

var _not_interactable = false # ultimate form
var _is_dead = false
var _is_invincible = false
var _is_cc_immune = true
var _is_slow_immune = true

##### All CC Variables #####

var _cc_count: int = 0 # counter for being cc'd
var _is_knockback: bool = false
var _is_slowed: bool = false
var _is_stunned: bool = false

###########################################################

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_init_stats()
	_init_timers()
	_init_collisions()
	_init_misc()
	_connect_signals()

func _init_stats() -> void:
	pass

func _init_timers() -> void:
	_dead_timer = _new_common_timer(_on_dead_timer_timeout)
	_invincible_timer = _new_common_timer(_on_invincible_timeout)

func _init_collisions() -> void:
	_hitbox.collision_layer = Types.Collision.DETECT_ONLY
	_hitbox.collision_mask = Types.Collision.NONE

func _init_misc() -> void:
	pass

func _connect_signals() -> void:
	_hitbox.area_entered.connect(_on_hitbox_enter)
	#_hitbox.area_exited.connect(_on_hitbox_exit)

func _dead() -> void:
	# start dead timer, queue_free if no dead animation, handle gold drops, etc.
	_not_interactable = true
	_is_dead = true
	_is_invincible = true
	
	_hitbox.monitorable = false

func _is_valid() -> bool:
	return !(_not_interactable or _is_dead)

func _new_common_timer(
	callable: Callable,
	wait_time: float = 1.0,
	one_shot: bool = true,
) -> Timer:
	var new_timer = Timer.new()
	new_timer.one_shot = one_shot
	new_timer.wait_time = wait_time
	new_timer.timeout.connect(callable)
	add_child(new_timer)
	return new_timer

func _new_temp_timer(
	timer_name: String, 
	callback_string: String,
	wait_time: float = 1.0,
	one_shot: bool = true,
) -> Timer:
	var new_timer = Timer.new()
	new_timer.name = timer_name
	new_timer.wait_time = wait_time
	new_timer.one_shot = true
	# To free the timer
	new_timer.timeout.connect(Callable(self, callback_string).bind(new_timer.name))
	add_child(new_timer)
	return new_timer

func _free_temp_timer(timer_name: String) -> void:
	if is_instance_valid(get_node(timer_name)) and get_node(timer_name):
		get_node(timer_name).queue_free()

func _on_hitbox_enter(other: Area2D) -> void:
	pass

#func _on_hitbox_exit(other: Area2D) -> void:
	#pass

func _on_dead_timer_timeout() -> void:
	self.queue_free()

func _on_invincible_timeout() -> void:
	_is_invincible = false

##########################################################
##### All CC virtual functions #####
##########################################################

func slow(duration: float) -> void:
	pass

func knockback(duration: float) -> void:
	pass

func stun(duration: float) -> void:
	pass

##########################################################

# this acts similarly to a constructor
func set_who(who: Types.Who) -> void:
	_who = who
