class_name FactionSelectMenu extends Control

#@onready var _buttons = $Buttons

func _on_monster_pressed() -> void:
	GameState.playing_as = Global.Faction.MONSTER
	LevelState.set_level_1()
	get_tree().change_scene_to_file(Paths.LEVELS + "level1.tscn")

func _on_darkness_pressed() -> void:
	GameState.playing_as = Global.Faction.DARKNESS
	LevelState.set_level_1()
	get_tree().change_scene_to_file(Paths.LEVELS + "level1.tscn")

func _on_undead_pressed() -> void:
	GameState.playing_as = Global.Faction.UNDEAD
	LevelState.set_level_1()
	get_tree().change_scene_to_file(Paths.LEVELS + "level1.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(Paths.MAIN_MENU + "main_menu.tscn")
