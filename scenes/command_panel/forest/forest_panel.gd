class_name ForestPanel extends CommandPanel

func _init_unit_base_data() -> void:
	unit1_data = ForestUnits.forestmage_data
	unit2_data = ForestUnits.ranger_data
	unit3_data = ForestUnits.protector_data
	unit4_data = ForestUnits.highelf_data

func _get_scene1() -> PackedScene:
	return load(Paths.FOREST + "forestmage.tscn")

func _get_scene2() -> PackedScene:
	return load(Paths.FOREST + "ranger.tscn")

func _get_scene3() -> PackedScene:
	return load(Paths.FOREST + "protector.tscn")

func _get_scene4() -> PackedScene:
	return load(Paths.FOREST + "highelf.tscn")
