extends Control
var slime_scene = preload("res://scenes/troops/slime.tscn") # Preload slime scene
var goblin_scene = preload("res://scenes/troops/goblin.tscn")
var giant_scene = preload("res://scenes/troops/giant.tscn")

@onready var good_tower = $VBoxScreenLayout/Battlefield/Good_Tower
@onready var bad_tower = $VBoxScreenLayout/Battlefield/Bad_Tower
@onready var tower_death_timer = $VBoxScreenLayout/Battlefield/Tower_Death_Timer

@onready var Q_Button = $HBoxButtonLayout/Q_Button
@onready var W_Button = $HBoxButtonLayout/W_Button
@onready var E_Button = $HBoxButtonLayout/E_Button
@onready var R_Button = $HBoxButtonLayout/R_Button

const ENEMY_MAX_TIME = 100 # Max chance reached after 100 summons
const ENEMY_SLIME_TARGET_CHANCE = 35.0
const ENEMY_GOBLIN_TARGET_CHANCE = 40.0
const ENEMY_GIANT_TARGET_CHANCE = 25.0

var enemy_spawn_timer: Timer;
var enemy_spawn_count = 0;
var enemy_slime_chance = 25.0;
var enemy_goblin_chance = 75.0;
var enemy_giant_chance = 0.0;

var tower_to_destroy = null;

var battlefield;
var command_panel;

var friendly_summon_location_Vector2: Vector2;
var enemy_summon_location_Vector2: Vector2;

var player_current_gold = Constants.STARTING_GOLD;
var q_cost = Constants.SLIME_PRICE;
var w_cost = Constants.GOBLIN_PRICE;
var e_cost = Constants.GIANT_PRICE;
var r_cost = Constants.LAB_PRICE;

var good_tower_health = Constants.BASE_MAX_HP;
var bad_tower_health = Constants.BASE_MAX_HP;

signal goodTowerHealthChange
signal badTowerHealthChange

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	battlefield = $VBoxScreenLayout/Battlefield
	command_panel = $VBoxScreenLayout/CommandPanel
	
	good_tower.play("vibe")
	bad_tower.play("vibe")
	
	var viewport_y = get_viewport_rect().size.y
	var ground_y = command_panel.get_global_rect().size.y

	# Determining summoning position
	var offset_y = -5
	friendly_summon_location_Vector2 = Vector2(Constants.FRIENDLY_BASE_X, viewport_y-ground_y-offset_y)
	enemy_summon_location_Vector2 = Vector2(Constants.ENEMY_BASE_X, viewport_y-ground_y-offset_y)
	
	enemy_spawn_timer = Timer.new()
	enemy_spawn_timer.one_shot = true  # We will manually restart with random intervals
	add_child(enemy_spawn_timer)
	enemy_spawn_timer.timeout.connect(_on_enemy_spawn_timeout)
	enemy_spawn_timer.start()
	
	update_costs()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Summon_1"):
		_on_q_pressed() 
	if Input.is_action_just_pressed("Summon_2"): 
		_on_w_pressed()
	if Input.is_action_just_pressed("Summon_3"): 
		_on_e_pressed()
	if Input.is_action_just_pressed("Discount"): 
		_on_r_pressed()
	Q_Button.disabled = player_current_gold < q_cost
	W_Button.disabled = player_current_gold < w_cost
	E_Button.disabled = player_current_gold < e_cost
	R_Button.disabled = player_current_gold < r_cost
	
func summon_troop(scene, friend: bool):
	var troop_instance = scene.instantiate()
	if friend:
		troop_instance.position = friendly_summon_location_Vector2
		get_node("NonUI/Friend_Troop_Container").add_child(troop_instance)
	else:
		troop_instance.set_as_enemy(enemy_summon_location_Vector2)
		get_node("NonUI/Enemy_Troop_Container").add_child(troop_instance)
	
func r_purchase():
	player_current_gold -= r_cost
	q_cost = max(1, floor(q_cost * 0.95))
	w_cost = max(1, floor(w_cost * 0.95))
	e_cost = max(1, floor(e_cost * 0.95))
	r_cost = floor(r_cost * 1.05)
	update_costs()
	
func update_costs():
	command_panel.get_node("q_cost/Label").text = "Q Cost: " + str(q_cost)
	command_panel.get_node("w_cost/Label").text = "W Cost: " + str(w_cost)
	command_panel.get_node("e_cost/Label").text = "E Cost: " + str(e_cost)
	command_panel.get_node("r_cost/Label").text = "R Cost: " + str(r_cost)

func _on_q_pressed() -> void:
	if player_current_gold >= q_cost:
		player_current_gold -= q_cost
		summon_troop(slime_scene, true)

func _on_w_pressed() -> void:
	if player_current_gold >= w_cost:
		player_current_gold -= w_cost
		summon_troop(goblin_scene, true)

func _on_e_pressed() -> void:
	if player_current_gold >= e_cost:
		player_current_gold -= e_cost
		summon_troop(giant_scene, true)
		
func _on_r_pressed() -> void:
	if player_current_gold >= r_cost:
		r_purchase()

func _on_add_gold_timer_timeout() -> void:
	player_current_gold += 2
	command_panel.get_node("total_gold/Label").text = "Gold: " + str(player_current_gold)
	
#########################################################

func set_enemy_spawn_time(interval: float) -> void:
	enemy_spawn_timer.wait_time = interval
	enemy_spawn_timer.start()

func damageGoodTower(damage: int) -> void:
	if good_tower_health - damage <= 0 and tower_to_destroy == null: # otherwise winner can be overrided
		tower_to_destroy = good_tower	
		good_tower.position.y = good_tower.position.y + 2.187 # fire is a bit off the ground
		good_tower.play("death")
		tower_death_timer.start()
	good_tower_health -= damage
	goodTowerHealthChange.emit()

func damageBadTower(damage: int) -> void:
	if bad_tower_health - damage <= 0 and tower_to_destroy == null:
		tower_to_destroy = bad_tower
		bad_tower.position.y = bad_tower.position.y + 2.187
		bad_tower.play("death")
		tower_death_timer.start()
	bad_tower_health -= damage
	badTowerHealthChange.emit()

func _on_tower_death_timer_timeout() -> void:
	tower_to_destroy.queue_free()
	if tower_to_destroy == bad_tower:
		get_tree().change_scene_to_file("res://scenes/menus/victory_scene.tscn")
	elif tower_to_destroy == good_tower:
		get_tree().change_scene_to_file("res://scenes/menus/defeat_scene.tscn")
		
func _on_enemy_spawn_timeout() -> void:
	# Choose a random enemy to spawn
	var progress = min(enemy_spawn_count / ENEMY_MAX_TIME, 1)
	enemy_slime_chance = lerp(enemy_slime_chance, ENEMY_SLIME_TARGET_CHANCE, progress);
	enemy_goblin_chance = lerp(enemy_goblin_chance, ENEMY_GOBLIN_TARGET_CHANCE, progress);
	enemy_giant_chance = lerp(enemy_giant_chance, ENEMY_GIANT_TARGET_CHANCE, progress);
	
	var random_enemy = randf_range(0, 100) # 0 to 99
	
	if random_enemy < enemy_slime_chance:
		summon_troop(slime_scene, false)
	elif random_enemy < enemy_slime_chance + enemy_goblin_chance:
		summon_troop(goblin_scene, false)
	else:
		summon_troop(giant_scene, false)

	# Randomize the next enemy spawn interval
	var random_interval;
	if enemy_spawn_count < 10:
		random_interval = randi_range(3, 7) # Generates a random interval between 2 and 7 seconds
	elif enemy_spawn_count < 25:
		random_interval = randi_range(2, 6)
	else:
		random_interval = randi_range(1, 5)
	set_enemy_spawn_time(random_interval)
		
	enemy_spawn_count += 1;
