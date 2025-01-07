class_name MonsterPanel extends CommandPanel

func _init_unit_base_data() -> void:
	unit1_data = MonsterUnits.goblin_data
	unit2_data = MonsterUnits.slime_data
	unit3_data = MonsterUnits.iceworm_data
	unit4_data = MonsterUnits.giant_data

func _get_scene1() -> PackedScene:
	return load(Paths.MONSTER + "goblin.tscn")

func _get_scene2() -> PackedScene:
	return load(Paths.MONSTER + "slime.tscn")

func _get_scene3() -> PackedScene:
	return load(Paths.MONSTER + "iceworm.tscn")

func _get_scene4() -> PackedScene:
	return load(Paths.MONSTER + "giant.tscn")
