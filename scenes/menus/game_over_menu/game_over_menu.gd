class_name GameOverMenu extends Control

@onready var _bg = $Bg
@onready var _who_wins = $Stats/WhoWins
@onready var _level_time = $Stats/LevelTime
@onready var _total_time = $Stats/TotalTime
@onready var _restarts = $Stats/Restarts

@onready var _continue = $Buttons/Continue

func _ready() -> void:
	GameState.total_game_time += LevelState.game_time
	if LevelState.who_wins == Global.Who.ALLY:
		_bg.color = Color(0, 255, 0)
		_who_wins.text = "You Win!"
		if LevelState.level_number == LevelState.MAX_LVL_NUMBER:
			_continue.visible = false
		else:
			_continue.text = "Next Level"
			_continue.pressed.connect(_on_next_level_pressed)
	if LevelState.who_wins == Global.Who.ENEMY:
		_bg.color = Color(255, 0, 0)
		_who_wins.text = "You Lose!"
		_continue.text = "Restart"
		_continue.pressed.connect(_on_restart_pressed)
	_level_time.text = "Level Time: " + Utils.format_time(LevelState.game_time)
	_total_time.text = "Total Time: " + Utils.format_time(GameState.total_game_time)
	_restarts.text = "Restarts this level: " + str(LevelState.restarts) + ", Total Restarts: " + str(GameState.total_restarts)

#func _change_scene(scene_path: String) -> void:
	#get_tree().change_scene_to_file(scene_path)

func _on_next_level_pressed() -> void:
	var level = LevelState.next_level()
	if level == 2: get_tree().change_scene_to_file(Paths.LEVELS + "level2.tscn")
	elif level == 3: get_tree().change_scene_to_file(Paths.LEVELS + "level3.tscn")

func _on_restart_pressed() -> void:
	var level = GameState.restart()
	if level == 1: get_tree().change_scene_to_file(Paths.LEVELS + "level1.tscn")
	elif level == 2: get_tree().change_scene_to_file(Paths.LEVELS + "level2.tscn")
	elif level == 3: get_tree().change_scene_to_file(Paths.LEVELS + "level3.tscn")

func _on_back_pressed() -> void:
	GameState.reset_game_state()
	get_tree().change_scene_to_file(Paths.MAIN_MENU + "main_menu.tscn")
