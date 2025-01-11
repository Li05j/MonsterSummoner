class_name Level extends Node

@onready var ally_base_scene = preload(Paths.BASE + "ally_base.tscn")
@onready var enemy_base_scene = preload(Paths.BASE + "enemy_base.tscn")

@onready var _ui = $UI
@onready var _game_time = $UI/GameTime

@onready var _panel

var _enemy_ai: EnemyAI
var _game_time_update_steps = 0 # we let game time update visually every 11 steps

#var _ally_base: AllyBase
#var _enemy_base: EnemyBase

func _ready() -> void:
	_init_level()

###############################################
###### CHEAT #####
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("cheat"):
		get_node("Enemy_base")._take_dmg(9999)
###############################################
		
func _process(delta: float) -> void:
	_update_game_time(delta)

func _init_level() -> void:
	LevelState.current_level = self
	_game_time.text = Utils.format_time(0)
	
	# Command panel
	_panel = GameState.get_command_panel_scene()
	_ui.add_child(_panel.instantiate())
	
	# Enemy AI init
	_enemy_ai = EnemyAI.new()
	LevelState.enemy_ai = _enemy_ai
	
	# Base locations
	var ally_base = ally_base_scene.instantiate()
	var enemy_base = enemy_base_scene.instantiate()
	ally_base.global_position = _decide_ally_base_location()
	enemy_base.global_position = _decide_enemy_base_location()
	LevelState.ally_base_pos = ally_base.global_position
	LevelState.enemy_base_pos = enemy_base.global_position
	add_child(ally_base)
	add_child(enemy_base)
	
	# Set a faction
	var enemy_faction: Global.Faction = _decide_enemy_faction()
	_enemy_ai.init_scenes(enemy_faction)
	LevelState.current_enemy_faction = enemy_faction
	GameState.remove_enemy_faction(enemy_faction)
	add_child(_enemy_ai)

# Same as player on level 1, else randomly select
func _decide_enemy_faction() -> Global.Faction:
	var enemy_faction: Global.Faction
	if LevelState.restarts == 0:
		if LevelState.level_number == 1:
			enemy_faction = GameState.playing_as
		else:
			var factions_left = GameState.enemy_factions_left
			var rand_idx: int = randi_range(0, factions_left.size() - 1)
			enemy_faction = factions_left[rand_idx]
	else:
		enemy_faction = LevelState.current_enemy_faction
	return enemy_faction

func _decide_ally_base_location() -> Vector2:
	if LevelState.restarts == 0:
		return Vector2(Global.ally_base_x, Global.ground_y)
	else:
		return LevelState.ally_base_pos

func _decide_enemy_base_location() -> Vector2:
	if LevelState.level_number == 1:
		return Vector2(Global.min_enemy_base_x, Global.ground_y)
	
	if LevelState.restarts == 0:
		var min = Global.min_enemy_base_x
		var max = Global.max_enemy_base_x
		var rand = randi_range(min, max)
		return Vector2(rand, Global.ground_y)
	else:
		return LevelState.enemy_base_pos

func _update_game_time(delta) -> void:
	if LevelState.who_wins == Global.Who.NONE:
		LevelState.game_time += delta
		_game_time_update_steps += 1
		if _game_time_update_steps >= 11:
			_game_time.text = Utils.format_time(LevelState.game_time)
			_game_time_update_steps = 0
	else:
		_game_time.text = Utils.format_time(LevelState.game_time)
