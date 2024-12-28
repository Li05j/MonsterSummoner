class_name GameOverMenu extends Control

@onready var _bg = $Bg
@onready var _who_wins = $Stats/WhoWins
@onready var _time = $Stats/Gametime

func _ready() -> void:
	if LevelState.who_wins == Types.Who.ALLY:
		_bg.color = Color(0, 255, 0)
		_who_wins.text = "You Win!"
	if LevelState.who_wins == Types.Who.ENEMY:
		_bg.color = Color(255, 0, 0)
		_who_wins.text = "You Lose!"
	_time.text = "Time: " + Utils.format_time(LevelState.game_time)

func _on_restart_pressed() -> void:
	LevelState.reset_level_state()
	get_tree().change_scene_to_file(Paths.LEVELS + "level1.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(Paths.MAIN_MENU + "main_menu.tscn")
