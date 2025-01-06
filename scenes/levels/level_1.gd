class_name Level1 extends Node

@onready var _ui = $UI
@onready var _game_time = $UI/GameTime

@onready var _panel

var _enemy_ai: EnemyAI
var _game_time_update_steps = 0 # we let game time update visually every 11 steps

func _ready() -> void:
	_init_level()

func _process(delta: float) -> void:
	_update_game_time(delta)

func _init_level() -> void:
	LevelState.current_level = self
	_game_time.text = Utils.format_time(0)
	
	_panel = GameState.get_command_panel_scene()
	_ui.add_child(_panel.instantiate())
	
	_enemy_ai = EnemyAI.new()
	LevelState.enemy_ai = _enemy_ai
	add_child(_enemy_ai)

func _update_game_time(delta) -> void:
	if LevelState.who_wins == Global.Who.NONE:
		LevelState.game_time += delta
		_game_time_update_steps += 1
		if _game_time_update_steps >= 11:
			_game_time.text = Utils.format_time(LevelState.game_time)
			_game_time_update_steps = 0
	else:
		_game_time.text = Utils.format_time(LevelState.game_time)
