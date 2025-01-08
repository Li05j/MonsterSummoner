class_name EnemyAI extends Node

var unit1_data
var unit2_data
var unit3_data
var unit4_data

var unit1_scene: PackedScene
var unit2_scene: PackedScene
var unit3_scene: PackedScene
var unit4_scene: PackedScene

var enemy_base: EnemyBase
var enemy_gold: int = 35
var enemy_gold_gen: int = 5

var gold_gen_timer: Timer
var gold_gen_increase_timer: Timer
var pot_of_gold_timer: Timer
var decision_timer: Timer

var behavior: EnemyAIBehavior

var critical_1_flag: bool = false
var critical_2_flag: bool = false

func _ready() -> void:
	match LevelState.level_number:
		1: 
			behavior = Level1AIBehavior.new()
		2: 
			enemy_gold *= 2
			enemy_gold_gen += 1
			behavior = Level2AIBehavior.new()
		3: 
			enemy_gold *= 3
			enemy_gold_gen += 2
			behavior = Level3AIBehavior.new()
		_: behavior = Level1AIBehavior.new()
	behavior.init(self)

	EventBus.unit_died.connect(_on_unit_died)
	
	enemy_base = LevelState.current_level.get_node("Enemy_base")
	gold_gen_timer = _new_common_timer(_on_gold_gen_timeout, 1.0, false)
	gold_gen_increase_timer = _new_common_timer(_on_gold_gen_increase_timeout, behavior.target_time_till_next_gold_gen_increase, true)
	pot_of_gold_timer = _new_common_timer(_on_pot_of_gold_timeout, behavior.pot_of_gold_time, false)
	decision_timer = _new_common_timer(_on_decision_timeout, behavior.generate_decision_wait_time())
	
	#TODO: Inefficient, gold gen increase and pot of gold can merge into gold gen timer probably
	gold_gen_timer.start()
	gold_gen_increase_timer.start()
	pot_of_gold_timer.start()
	decision_timer.start()

func init_scenes(faction: Global.Faction) -> void:
	match faction:
		Global.Faction.MONSTER:
			unit1_data = MonsterUnits.goblin_data
			unit2_data = MonsterUnits.slime_data
			unit3_data = MonsterUnits.iceworm_data
			unit4_data = MonsterUnits.giant_data
	
			unit1_scene = preload(Paths.MONSTER + "goblin.tscn")
			unit2_scene = preload(Paths.MONSTER + "slime.tscn")
			unit3_scene = preload(Paths.MONSTER + "iceworm.tscn")
			unit4_scene = preload(Paths.MONSTER + "giant.tscn")
		Global.Faction.DARKNESS:
			unit1_data = DarknessUnits.shadowarcher_data
			unit2_data = DarknessUnits.nightborne_data
			unit3_data = DarknessUnits.darkknight_data
			unit4_data = DarknessUnits.doomsday_data
	
			unit1_scene = preload(Paths.DARKNESS + "shadowarcher.tscn")
			unit2_scene = preload(Paths.DARKNESS + "nightborne.tscn")
			unit3_scene = preload(Paths.DARKNESS + "darkknight.tscn")
			unit4_scene = preload(Paths.DARKNESS + "doomsday.tscn")
		Global.Faction.UNDEAD:
			unit1_data = UndeadUnits.skeleton_data
			unit2_data = UndeadUnits.ghost_data
			unit3_data = UndeadUnits.undead_witch_data
			unit4_data = UndeadUnits.reaper_data
	
			unit1_scene = preload(Paths.UNDEAD + "skeleton.tscn")
			unit2_scene = preload(Paths.UNDEAD + "ghost.tscn")
			unit3_scene = preload(Paths.UNDEAD + "undeadwitch.tscn")
			unit4_scene = preload(Paths.UNDEAD + "reaper.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !critical_1_flag and enemy_base.get_hp_percent() <= behavior.critical_hp_1:
		critical_1_flag = true
		var amount = behavior.get_pot_of_gold_value(1)
		print("critical 1: " + str(amount))
		enemy_gold += amount
	if !critical_2_flag and enemy_base.get_hp_percent() <= behavior.critical_hp_2:
		critical_2_flag = true
		var amount = behavior.get_pot_of_gold_value(2)
		print("critical 2: " + str(amount))
		enemy_gold += amount

func _new_common_timer(
	callable: Callable,
	wait_time: float = 1.0,
	one_shot: bool = true,
) -> Timer:
	var new_timer = Timer.new()
	new_timer.one_shot = one_shot
	new_timer.wait_time = wait_time
	new_timer.timeout.connect(callable)
	add_child(new_timer)
	return new_timer

func _check_if_affordable(cost: int) -> bool:
	if enemy_gold >= cost:
		return true
	return false

func _on_gold_gen_timeout() -> void:
	enemy_gold += enemy_gold_gen
	print(enemy_gold)

func _on_gold_gen_increase_timeout() -> void:
	enemy_gold_gen += 1
	behavior.target_time_till_next_gold_gen_increase += behavior.target_gold_gen_time_step
	gold_gen_increase_timer.start(behavior.target_time_till_next_gold_gen_increase)

func _on_pot_of_gold_timeout() -> void:
	enemy_gold += behavior.get_pot_of_gold_value(0)

func _on_decision_timeout() -> void:
	summon(behavior.decide_what_to_do())
	decision_timer.start(behavior.generate_decision_wait_time())

func _on_unit_died(who, gold_drop):
	if who == Global.Who.ALLY:
		enemy_gold += gold_drop

# which = 1 to 4
func summon(which: int) -> void:
	var scene
	match which:
		1: 
			enemy_gold -= unit1_data.cost
			scene = unit1_scene.instantiate()
		2: 
			enemy_gold -= unit2_data.cost
			scene = unit2_scene.instantiate()
		3: 
			enemy_gold -= unit3_data.cost
			scene = unit3_scene.instantiate()
		4: 
			enemy_gold -= unit4_data.cost
			scene = unit4_scene.instantiate()
		_: return
	LevelState.current_level.add_child(scene)
	scene.set_who(Global.Who.ENEMY)
	
