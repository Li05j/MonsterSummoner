class_name Unit extends Node2D

@onready var _sprite = $AnimatedSprite2D
@onready var _hitbox = _sprite.get_node("HitboxArea")

var _dead_timer: Timer
var _invincible_timer: Timer

var _who: Types.Who = Types.Who.NONE

##########################################################
##### States #####

var _cc_count: int = 0 # counter for being cc'd

var _not_interactable = false # ultimate form
var _is_dead = false
var _is_invincible = false
var _is_cc_immune = true

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
	_add_dead_timer()
	_add_invincible_timer()

func _init_collisions() -> void:
	_hitbox.collision_layer = Types.Collision.DETECT_ONLY
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

func _dead() -> void:
	# start dead timer, queue_free if no dead animation, handle gold drops, etc.
	_not_interactable = true
	_is_dead = true
	_is_invincible = true

func _on_hitbox_enter(other: Area2D) -> void:
	pass

func _on_hitbox_exit(other: Area2D) -> void:
	pass

func _on_dead_timer_timeout() -> void:
	self.queue_free()

func _on_invincible_timeout() -> void:
	_is_invincible = false

# this acts similarly to a constructor
func set_who(who: Types.Who) -> void:
	_who = who
