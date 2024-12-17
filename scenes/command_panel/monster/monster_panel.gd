class_name MonsterPanel extends Panel

@onready var unit1 = $Buttons/Unit1
@onready var unit2 = $Buttons/Unit2
@onready var unit3 = $Buttons/Unit3
@onready var unit4 = $Buttons/Unit4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	unit1.get_node("Cost").text = "500"
	unit2.get_node("Cost").text = "20"
	unit3.get_node("Cost").text = "400"
	unit4.get_node("Cost").text = "9999"
