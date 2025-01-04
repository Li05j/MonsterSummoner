class_name MonsterPanel extends Panel

@onready var gold_gen_timer = $GoldGenTimer
@onready var player_gold = $Panel/PlayerGold

@onready var unit_buttons = $UnitButtons
@onready var building_buttons = $BuildingButtons

@onready var unit1: Button = unit_buttons.get_node("Unit1")
@onready var unit2 = unit_buttons.get_node("Unit2")
@onready var unit3 = unit_buttons.get_node("Unit3")
@onready var unit4 = unit_buttons.get_node("Unit4")

@onready var build1 = building_buttons.get_node("Build1")
@onready var build2 = building_buttons.get_node("Build2")
@onready var build3 = building_buttons.get_node("Build3")
@onready var build4 = building_buttons.get_node("Build4")

var goblin_scene = preload(Paths.MONSTER + "goblin.tscn")
var slime_scene = preload(Paths.MONSTER + "slime.tscn")
var iceworm_scene = preload(Paths.MONSTER + "iceworm.tscn")
var giant_scene = preload(Paths.MONSTER + "giant.tscn")

var unit1_cost = MonsterUnits.goblin_data.cost
var unit2_cost = MonsterUnits.slime_data.cost
var unit3_cost = MonsterUnits.iceworm_data.cost
var unit4_cost = MonsterUnits.giant_data.cost

var build1_cost = BuildingsData.gold_mine.cost
var build2_cost = BuildingsData.lab.cost

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_init_unit_price()
	_init_building_price()
	_init_text_display()
	_init_tooltips()
	_connect_signals()

func _input(event: InputEvent) -> void:
	if event.is_action_released("summon1"):
		_on_unit_1_pressed()
	elif event.is_action_released("summon2"):
		_on_unit_2_pressed()
	elif event.is_action_released("summon3"):
		_on_unit_3_pressed()
	elif event.is_action_released("summon4"):
		_on_unit_4_pressed()
		
	elif event.is_action_released("build1"):
		_on_build_1_pressed()
	elif event.is_action_released("build2"):
		_on_build_2_pressed()
	elif event.is_action_released("build3"):
		_on_build_3_pressed()
	elif event.is_action_released("build4"):
		_on_build_4_pressed()

func _init_unit_price() -> void:
	unit1.get_node("Cost").text = str(unit1_cost)
	unit2.get_node("Cost").text = str(unit2_cost)
	unit3.get_node("Cost").text = str(unit3_cost)
	unit4.get_node("Cost").text = str(unit4_cost)

func _init_building_price() -> void:
	build1.get_node("Cost").text = str(build1_cost)
	build2.get_node("Cost").text = str(build2_cost)
	build3.get_node("Cost").text = "400"
	build4.get_node("Cost").text = "9999"

func _init_text_display() -> void:
	_update_gold_display_text()

func _init_tooltips() -> void:
	unit1.tooltip_text = "HP: %s\nAttack: %s\nAttack Rate: %s\nTargets: %s\n\n%s" % [
		MonsterUnits.goblin_data.max_hp,
		MonsterUnits.goblin_data.atk,
		MonsterUnits.goblin_data.atk_spd,
		MonsterUnits.goblin_data.targets,
		MonsterUnits.goblin_data.description,
	]
	unit2.tooltip_text = "HP: %s\nAttack: %s\nAttack Rate: %s\nTargets: %s\n\n%s" % [
		MonsterUnits.slime_data.max_hp,
		MonsterUnits.slime_data.atk,
		MonsterUnits.slime_data.atk_spd,
		MonsterUnits.slime_data.targets,
		MonsterUnits.slime_data.description,
	]
	unit3.tooltip_text = "HP: %s\nAttack: %s\nAttack Rate: %s\nTargets: %s\n\n%s" % [
		MonsterUnits.iceworm_data.max_hp,
		MonsterUnits.iceworm_data.atk,
		MonsterUnits.iceworm_data.atk_spd,
		MonsterUnits.iceworm_data.targets,
		MonsterUnits.iceworm_data.description,
	]
	unit4.tooltip_text = "HP: %s\nAttack: %s\nAttack Rate: %s\nTargets: %s\n\n%s" % [
		MonsterUnits.giant_data.max_hp,
		MonsterUnits.giant_data.atk,
		MonsterUnits.giant_data.atk_spd,
		#MonsterUnits.giant_data.targets,
		"All",
		MonsterUnits.giant_data.description,
	]
	
	build1.tooltip_text = BuildingsData.gold_mine.description
	build2.tooltip_text = BuildingsData.lab.description

func _connect_signals() -> void:
	EventBus.player_gold_text_changed.connect(_update_gold_display_text)

func _summon(cost: int, scene) -> void:
	if LevelState.player_gold >= cost:
		var new_scene = scene.instantiate()
		LevelState.current_level.add_child(new_scene)
		new_scene.set_who(Types.Who.ALLY)
		LevelState.player_gold -= cost
		_update_gold_display_text()

func _update_units_price(rate: float) -> void:
	unit1_cost = floor(unit1_cost * rate)
	unit2_cost = floor(unit2_cost * rate)
	unit3_cost = floor(unit3_cost * rate)
	unit4_cost = floor(unit4_cost * rate)

func _update_units_price_text() -> void:
	unit1.get_node("Cost").text = str(unit1_cost)
	unit2.get_node("Cost").text = str(unit2_cost)
	unit3.get_node("Cost").text = str(unit3_cost)
	unit4.get_node("Cost").text = str(unit4_cost)

func _update_buildings_price(rate: float) -> void:
	build1_cost = floor(build1_cost * rate)
	build2_cost = floor(build2_cost * rate)

func _update_buildings_price_text() -> void:
	build1.get_node("Cost").text = str(build1_cost)
	build2.get_node("Cost").text = str(build2_cost)

func _update_gold_display_text() -> void:
	player_gold.text = "GOLD: %d (+%d)" % [LevelState.player_gold, LevelState.player_gold_gen]

func _on_gold_gen_timer_timeout() -> void:
	LevelState.player_gold += LevelState.player_gold_gen
	_update_gold_display_text()

func _on_unit_1_pressed() -> void:
	_summon(unit1_cost, goblin_scene)

func _on_unit_2_pressed() -> void:
	_summon(unit2_cost, slime_scene)

func _on_unit_3_pressed() -> void:
	_summon(unit3_cost, iceworm_scene)

func _on_unit_4_pressed() -> void:
	_summon(unit4_cost, giant_scene)

func _on_build_1_pressed() -> void:
	if LevelState.player_gold >= build1_cost:
		var new_gold_gen = floor(LevelState.player_gold_gen * BuildingsData.gold_mine.income_increase_rate)
		LevelState.player_gold_gen += max(1, new_gold_gen)
		LevelState.player_gold -= build1_cost
		build1_cost = floor(build1_cost * BuildingsData.gold_mine.price_increase_rate)
		_update_gold_display_text()
		_update_buildings_price_text()

func _on_build_2_pressed() -> void:
	if LevelState.player_gold >= build2_cost:
		_update_units_price(BuildingsData.lab.reduction_percent)
		_update_buildings_price(BuildingsData.lab.reduction_percent)
		LevelState.player_gold -= build2_cost
		build2_cost = floor(build2_cost * BuildingsData.lab.price_increase_rate)
		_update_gold_display_text()
		_update_units_price_text()
		_update_buildings_price_text()

func _on_build_3_pressed() -> void:
	pass # Replace with function body.

func _on_build_4_pressed() -> void:
	pass # Replace with function body.
