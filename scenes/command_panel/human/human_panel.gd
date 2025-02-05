class_name HumanPanel extends CommandPanel

func _init_unit_base_data() -> void:
	unit1_data = HumanUnits.adventurer_data
	unit2_data = HumanUnits.mage_data
	unit3_data = HumanUnits.guardian_data
	unit4_data = HumanUnits.king_data

func _get_scene1() -> PackedScene:
	return preload(Paths.HUMAN + "adventurer.tscn")

func _get_scene2() -> PackedScene:
	return preload(Paths.HUMAN + "mage.tscn")

func _get_scene3() -> PackedScene:
	return preload(Paths.HUMAN + "guardian.tscn")

func _get_scene4() -> PackedScene:
	return preload(Paths.HUMAN + "king.tscn")
