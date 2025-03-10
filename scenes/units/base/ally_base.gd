class_name AllyBase extends BattleUnit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_init_stats()
	_init_timers()
	_init_collisions()
	_init_misc()
	_connect_signals()

func _init_stats() -> void:
	_max_hp = Global.max_base_hp

func _init_collisions() -> void:
	_hitbox.collision_layer = Global.Collision.PLAYER_BASE
	_hitbox.collision_mask = Global.Collision.ENEMY_UNIT | Global.Collision.ENEMY_PROJ

func _init_misc() -> void:
	set_who(Global.Who.ALLY)
	add_to_group("ally_unit")
	super()
	_current_hp = GameState.ally_base_hp_left
	_hp_bar.value = _current_hp

func _connect_signals() -> void:
	super()
	EventBus.enemy_base_destroyed.connect(_on_enemy_base_destroyed)

func _dead() -> void:
	super()
	if LevelState.who_wins == Global.Who.NONE:
		LevelState.who_wins = Global.Who.ENEMY
		_sprite.play("dead")
		_sprite.offset.y = -55
		_dead_timer.start(Global.base_death_animation_duration)

func _on_dead_timer_timeout() -> void:
	super()
	get_tree().change_scene_to_file(Paths.GAME_OVER_MENU + "game_over_menu.tscn")

func _on_enemy_base_destroyed() -> void:
	_is_invincible = true
