class_name MonsterPanel extends Panel

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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_unit_price()
	init_building_price()

func init_unit_price() -> void:
	unit1.get_node("Cost").text = "500"
	unit2.get_node("Cost").text = "20"
	unit3.get_node("Cost").text = "400"
	unit4.get_node("Cost").text = "9999"

func init_building_price() -> void:
	build1.get_node("Cost").text = "500"
	build2.get_node("Cost").text = "20"
	build3.get_node("Cost").text = "400"
	build4.get_node("Cost").text = "9999"

func update_units_price(change: int) -> void:
	pass

func update_buildings_price(change: int) -> void:
	pass
