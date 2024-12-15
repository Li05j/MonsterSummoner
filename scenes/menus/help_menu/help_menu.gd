class_name HelpMenu extends Control

func _on_back_btn_pressed() -> void:
	get_tree().change_scene_to_file(Paths.MAIN_MENU + "main_menu.tscn")
