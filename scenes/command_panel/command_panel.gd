class_name CommandPanel extends Panel

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

var unit1_data
var unit2_data
var unit3_data
var unit4_data

var unit1_cost
var unit2_cost
var unit3_cost
var unit4_cost

var build1_cost = BuildingsData.gold_mine.cost
var build2_cost = BuildingsData.lab.cost

var build1_count = 0
var build2_count = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_init_unit_base_data()
	_init_unit_additional_data()
	_apply_past_upgrades()
	_init_unit_price_text()
	_init_building_price_text()
	_init_other_text_display()
	_init_tooltips_text()
	_connect_signals()

############ OVERWRITE these please . ############
func _init_unit_base_data() -> void:
	pass

func _get_scene1() -> PackedScene:
	return null

func _get_scene2() -> PackedScene:
	return null

func _get_scene3() -> PackedScene:
	return null

func _get_scene4() -> PackedScene:
	return null

############################################################

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

func _init_unit_additional_data() -> void:
	unit1_cost = unit1_data.cost
	unit2_cost = unit2_data.cost
	unit3_cost = unit3_data.cost
	unit4_cost = unit4_data.cost

func _apply_past_upgrades() ->  void:
	build1_count = GameState.build1_count
	build2_count = GameState.build2_count
	
	for i in build1_count:
		_apply_build_1_benefits()
	for i in build2_count:
		_apply_build_2_benefits()

func _init_unit_price_text() -> void:
	unit1.get_node("Cost").text = str(unit1_cost)
	unit2.get_node("Cost").text = str(unit2_cost)
	unit3.get_node("Cost").text = str(unit3_cost)
	unit4.get_node("Cost").text = str(unit4_cost)

func _init_building_price_text() -> void:
	build1.get_node("Cost").text = str(build1_cost)
	build2.get_node("Cost").text = str(build2_cost)
	build3.get_node("Cost").text = "400"
	build4.get_node("Cost").text = "9999"

func _init_other_text_display() -> void:
	_update_gold_display_text()

func _init_tooltips_text() -> void:
	unit1.tooltip_text = _write_tooltip(unit1_data)
	unit2.tooltip_text = _write_tooltip(unit2_data)
	unit3.tooltip_text = _write_tooltip(unit3_data)
	unit4.tooltip_text = _write_tooltip(unit4_data)
	
	build1.tooltip_text = BuildingsData.gold_mine.description
	build2.tooltip_text = BuildingsData.lab.description

func _connect_signals() -> void:
	EventBus.player_gold_text_changed.connect(_update_gold_display_text)
	EventBus.enemy_base_destroyed.connect(_on_enemy_base_destroyed)

func _write_tooltip(data: Dictionary) -> String:
	return "HP: %s\nAttack: %s\nAttack Rate: %s\nTargets: %s\n\n%s" % [
		data.max_hp,
		data.atk,
		data.atk_spd,
		data.targets if data.targets != -1 else "All",
		data.description,
	]

func _summon(cost: int, scene) -> void:
	if LevelState.player_gold >= cost:
		var new_instance = scene.instantiate()
		LevelState.current_level.add_child(new_instance)
		new_instance.set_who(Global.Who.ALLY)
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

func _on_enemy_base_destroyed() -> void:
	GameState.save_upgrades(build1_count, build2_count)

func _on_unit_1_pressed() -> void:
	_summon(unit1_cost, _get_scene1())

func _on_unit_2_pressed() -> void:
	_summon(unit2_cost, _get_scene2())

func _on_unit_3_pressed() -> void:
	_summon(unit3_cost, _get_scene3())

func _on_unit_4_pressed() -> void:
	_summon(unit4_cost, _get_scene4())

func _on_build_1_pressed() -> void:
	if LevelState.player_gold >= build1_cost:
		build1_count += 1
		LevelState.player_gold -= build1_cost
		_apply_build_1_benefits()
		_update_gold_display_text()
		_update_buildings_price_text()

func _apply_build_1_benefits() -> void:
	#var new_gold_gen = floor(LevelState.player_gold_gen * BuildingsData.gold_mine.income_increase_rate)
	#LevelState.player_gold_gen += max(1, new_gold_gen)
	LevelState.player_gold_gen += BuildingsData.gold_mine.income_increase_flat
	build1_cost = floor(build1_cost * BuildingsData.gold_mine.price_increase_rate)

func _on_build_2_pressed() -> void:
	if LevelState.player_gold >= build2_cost:
		build2_count += 1
		LevelState.player_gold -= build2_cost
		_apply_build_2_benefits()
		_update_gold_display_text()
		_update_units_price_text()
		_update_buildings_price_text()

func _apply_build_2_benefits() -> void:
	_update_units_price(BuildingsData.lab.reduction_percent)
	_update_buildings_price(BuildingsData.lab.reduction_percent)
	build2_cost = floor(build2_cost * BuildingsData.lab.price_increase_rate)

func _on_build_3_pressed() -> void:
	pass # Replace with function body.

func _on_build_4_pressed() -> void:
	pass # Replace with function body.
