class_name Level extends Node

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
	if LevelState.level_number == 1:
		_enemy_ai.init_scenes(GameState.playing_as)
	else:
		var factions_left = GameState.enemy_factions_left
		var rand_idx: int = randi_range(0, factions_left.size() - 1)
		
		_enemy_ai.init_scenes(factions_left[rand_idx])
		GameState.remove_enemy_faction(factions_left[rand_idx])
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
