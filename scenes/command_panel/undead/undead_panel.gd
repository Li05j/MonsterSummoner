class_name UndeadPanel extends CommandPanel

func _init_unit_base_data() -> void:
	unit1_data = UndeadUnits.skeleton_data
	unit2_data = UndeadUnits.ghost_data
	unit3_data = UndeadUnits.undead_witch_data
	unit4_data = UndeadUnits.reaper_data

func _get_scene1() -> PackedScene:
	return preload(Paths.UNDEAD + "skeleton.tscn")

func _get_scene2() -> PackedScene:
	return preload(Paths.UNDEAD + "ghost.tscn")

func _get_scene3() -> PackedScene:
	return preload(Paths.UNDEAD + "undeadwitch.tscn")

func _get_scene4() -> PackedScene:
	return preload(Paths.UNDEAD + "reaper.tscn")
