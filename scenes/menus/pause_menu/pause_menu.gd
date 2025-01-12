class_name PauseMenu extends Control

@export var fade_in_duration := 0.3
@export var fade_out_duration := 0.2

@onready var center_cont := $ColorRect/CenterContainer as CenterContainer

func _ready() -> void:
	hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		var tree := get_tree()
		tree.paused = not tree.paused
		if tree.paused:
			open()
		else:
			close()

func close() -> void:
	var tween := create_tween()
	get_tree().paused = false
	tween.tween_property(
		self,
		^"modulate:a",
		0.0,
		fade_out_duration
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(
		center_cont,
		^"anchor_bottom",
		0.5,
		fade_out_duration
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_callback(hide)

func open() -> void:
	show()

	modulate.a = 0.0
	center_cont.anchor_bottom = 0.5
	var tween := create_tween()
	tween.tween_property(
		self,
		^"modulate:a",
		1.0,
		fade_in_duration
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(
		center_cont,
		^"anchor_bottom",
		1.0,
		fade_out_duration
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func _on_resume_button_pressed() -> void:
	close()

func _on_restart_pressed() -> void:
	close()
	var level = GameState.restart()
	if level == 1: get_tree().change_scene_to_file(Paths.LEVELS + "level.tscn")
	elif level == 2: get_tree().change_scene_to_file(Paths.LEVELS + "level.tscn")
	elif level == 3: get_tree().change_scene_to_file(Paths.LEVELS + "level.tscn")

func _on_quit_button_pressed() -> void:
	if visible:
		close()
		GameState.reset_game_state()
		get_tree().change_scene_to_file(Paths.MAIN_MENU + "main_menu.tscn")
