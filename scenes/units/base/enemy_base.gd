class_name EnemyBase extends BattleUnit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_init_stats()
	_init_timers()
	_init_collisions()
	_init_misc()
	_connect_signals()

func _init_stats() -> void:
	_max_hp = 1000

func _init_collisions() -> void:
	_hitbox.collision_layer = Types.Collision.ENEMY_BASE
	_hitbox.collision_mask = Types.Collision.PLAYER_UNIT | Types.Collision.PLAYER_PROJ

func _init_misc() -> void:
	set_who(Types.Who.ENEMY)
	add_to_group("enemy_unit")
	super()

func _dead() -> void:
	super()
	if LevelState.who_wins == Types.Who.NONE:
		LevelState.who_wins = Types.Who.ALLY
		_sprite.play("dead")
		_dead_timer.start(7)

func _on_dead_timer_timeout() -> void:
	super()
	get_tree().change_scene_to_file(Paths.GAME_OVER_MENU + "game_over_menu.tscn")
