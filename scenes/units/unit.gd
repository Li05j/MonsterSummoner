class_name Unit extends Node2D

@onready var _sprite = $AnimatedSprite2D
@onready var _hitbox = $HitboxArea

var _dead_timer: Timer
var _invincible_timer: Timer

var _who: Types.Who = Types.Who.NONE

##########################################################
##### States #####

var _is_dead = false
var _is_invincible = true

###########################################################

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_init_position()
	_init_timers()
	_init_collisions()
	_init_misc()
	_connect_signals()

func _init_position() -> void:
	pass

func _init_timers() -> void:
	_add_dead_timer()
	_add_invincible_timer()

func _init_collisions() -> void:
	_hitbox.collision_layer = Types.Collision.NONE
	_hitbox.collision_mask = Types.Collision.NONE

func _init_misc() -> void:
	pass

func _connect_signals() -> void:
	_hitbox.body_entered.connect(_on_hitbox_enter)
	_hitbox.body_exited.connect(_on_hitbox_exit)

func _add_dead_timer() -> void:
	_dead_timer = Timer.new()
	_dead_timer.one_shot = true
	_dead_timer.timeout.connect(_on_dead_timer_timeout) # Gracefully deletes this instance after timer, i.e. self destruct
	add_child(_dead_timer)

func _add_invincible_timer() -> void:
	_invincible_timer = Timer.new()
	_invincible_timer.one_shot = true
	_invincible_timer.timeout.connect(_on_invincible_timeout)
	add_child(_invincible_timer)

func _set_who(who: Types.Who) -> void:
	_who = who

func _dead() -> void:
	# start dead timer, queue_free if no dead animation, handle gold drops, etc.
	self.queue_free()

func _on_hitbox_enter() -> void:
	pass

func _on_hitbox_exit() -> void:
	pass

func _on_dead_timer_timeout() -> void:
	self.queue_free()

func _on_invincible_timeout() -> void:
	_is_invincible = false
