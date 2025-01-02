class_name MonsterPanel extends Panel

@onready var gold_gen_timer = $GoldGenTimer
@onready var player_gold = $Panel/PlayerGold

@onready var unit_buttons = $UnitButtons
@onready var building_buttons = $BuildingButtons

@onready var unit1 = unit_buttons.get_node("Unit1")
@onready var unit2 = unit_buttons.get_node("Unit2")
@onready var unit3 = unit_buttons.get_node("Unit3")
@onready var unit4 = unit_buttons.get_node("Unit4")

@onready var build1 = building_buttons.get_node("Build1")
@onready var build2 = building_buttons.get_node("Build2")
@onready var build3 = building_buttons.get_node("Build3")
@onready var build4 = building_buttons.get_node("Build4")

var goblin_scene = preload(Paths.MONSTER + "goblin.tscn")
var slime_scene = preload(Paths.MONSTER + "slime.tscn")
var fireworm_scene = preload(Paths.MONSTER + "fireworm.tscn")
var giant_scene = preload(Paths.MONSTER + "giant.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_init_unit_price()
	_init_building_price()
	_init_text_display()

func _init_unit_price() -> void:
	unit1.get_node("Cost").text = "500"
	unit2.get_node("Cost").text = "20"
	unit3.get_node("Cost").text = "400"
	unit4.get_node("Cost").text = "9999"

func _init_building_price() -> void:
	build1.get_node("Cost").text = "500"
	build2.get_node("Cost").text = "20"
	build3.get_node("Cost").text = "400"
	build4.get_node("Cost").text = "9999"

func _init_text_display() -> void:
	player_gold.text = "GOLD: %d (+%d)" % [LevelState.player_gold, LevelState.player_gold_gen]

func _on_gold_gen_timer_timeout() -> void:
	LevelState.player_gold += LevelState.player_gold_gen
	player_gold.text = "GOLD: %d (+%d)" % [LevelState.player_gold, LevelState.player_gold_gen]

func _on_unit_1_pressed() -> void:
	var scene = goblin_scene.instantiate()
	LevelState.current_level.add_child(scene)
	scene.set_who(Types.Who.ALLY)

func _on_unit_2_pressed() -> void:
	var scene = slime_scene.instantiate()
	LevelState.current_level.add_child(scene)
	scene.set_who(Types.Who.ALLY)

func _on_unit_3_pressed() -> void:
	var scene = fireworm_scene.instantiate()
	LevelState.current_level.add_child(scene)
	scene.set_who(Types.Who.ALLY)

func _on_unit_4_pressed() -> void:
	var scene = giant_scene.instantiate()
	LevelState.current_level.add_child(scene)
	scene.set_who(Types.Who.ALLY)

func update_units_price(change: int) -> void:
	pass

func update_buildings_price(change: int) -> void:
	pass
