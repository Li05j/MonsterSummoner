class_name DarknessPanel extends CommandPanel

func _init_unit_base_data() -> void:
	unit1_data = DarknessUnits.shadowarcher_data
	unit2_data = DarknessUnits.nightborne_data
	unit3_data = DarknessUnits.darkknight_data
	unit4_data = DarknessUnits.doomsday_data

func _get_scene1() -> PackedScene:
	return preload(Paths.DARKNESS + "shadowarcher.tscn")

func _get_scene2() -> PackedScene:
	return preload(Paths.DARKNESS + "nightborne.tscn")

func _get_scene3() -> PackedScene:
	return preload(Paths.DARKNESS + "darkknight.tscn")

func _get_scene4() -> PackedScene:
	return preload(Paths.DARKNESS + "doomsday.tscn")
