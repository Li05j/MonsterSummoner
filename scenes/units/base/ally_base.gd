class_name AllyBase extends BattleUnit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_init_position()
	_init_timers()
	_init_collisions()
	_init_misc()
	_connect_signals()

func _init_misc() -> void:
	_max_hp = 1000
	super()

func _dead() -> void:
	super()
	if LevelState.who_wins == Types.Who.NONE:
		LevelState.who_wins = Types.Who.ENEMY
		_dead_timer.start(7)

func _on_dead_timer_timeout() -> void:
	super()
	get_tree().change_scene_to_file(Paths.GAME_OVER_MENU + "game_over_menu.tscn")
