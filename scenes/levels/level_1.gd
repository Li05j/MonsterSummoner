class_name Level1 extends Node

@onready var game_time = $UI/GameTime

func _ready() -> void:
	_init_level()

func _process(delta: float) -> void:
	_update_game_time(delta)

func _init_level() -> void:
	game_time.text = Utils.format_time(0)

func _update_game_time(delta) -> void:
	LevelState.game_time += delta
	game_time.text = Utils.format_time(LevelState.game_time)
