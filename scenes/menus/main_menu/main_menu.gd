class_name MainMenu extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Title.text = "MONSTER SUMMONER"
	#$Buttons/StartGame.grab_focus()

func _on_start_btn_pressed() -> void:
	get_tree().change_scene_to_file(Paths.LEVELS + "level1.tscn")

func _on_help_btn_pressed() -> void:
	get_tree().change_scene_to_file(Paths.HELP_MENU + "help_menu.tscn")

func _on_quit_btn_pressed() -> void:
	get_tree().quit()
