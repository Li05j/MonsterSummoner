class_name EnemyAI extends Node

#var goblin_scene = preload(Paths.MONSTER + "goblin.tscn")
#var slime_scene = preload(Paths.MONSTER + "slime.tscn")
#var iceworm_scene = preload(Paths.MONSTER + "iceworm.tscn")
#var giant_scene = preload(Paths.MONSTER + "giant.tscn")

var shadowarcher_scene = preload(Paths.DARKNESS + "shadowarcher.tscn")
var nightborne_scene = preload(Paths.DARKNESS + "nightborne.tscn")
var darkknight_scene = preload(Paths.DARKNESS + "darkknight.tscn")
var doomsday_scene = preload(Paths.DARKNESS + "doomsday.tscn")

#var skeleton_scene = preload(Paths.UNDEAD + "skeleton.tscn")
#var ghost_scene = preload(Paths.UNDEAD + "ghost.tscn")
#var undeadwitch_scene = preload(Paths.UNDEAD + "undeadwitch.tscn")
#var reaper_scene = preload(Paths.UNDEAD + "reaper.tscn")

var enemy_base: EnemyBase
var enemy_gold: int = 50
var enemy_gold_gen: int = 5

var gold_gen_timer: Timer
var gold_gen_increase_timer: Timer
var pot_of_gold_timer: Timer
var decision_timer: Timer

var behavior: EnemyAIBehavior

var critical_1_flag: bool = false
var critical_2_flag: bool = false

func _ready() -> void:
	behavior = ConserveAIBehavior.new()
	behavior.set_ai(self)
	
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !critical_1_flag and enemy_base.get_hp_percent() <= behavior.critical_hp_1:
		critical_1_flag = true
		enemy_gold += behavior.get_pot_of_gold_value(1)
	if !critical_2_flag and enemy_base.get_hp_percent() <= behavior.critical_hp_2:
		critical_2_flag = true
		enemy_gold += behavior.get_pot_of_gold_value(2)

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

func _try_to_purchase(cost: int) -> bool:
	if enemy_gold >= cost:
		enemy_gold -= cost
		return true
	return false

func _on_gold_gen_timeout() -> void:
	enemy_gold += enemy_gold_gen
	#print(enemy_gold)

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
		#1: 
			#if _try_to_purchase(UndeadUnits.skeleton_data.cost):
				#scene = skeleton_scene.instantiate()
			#else:
				#return
		#2: 
			#if _try_to_purchase(UndeadUnits.ghost_data.cost):
				#scene = ghost_scene.instantiate()
			#else:
				#return
		#3: 
			#if _try_to_purchase(UndeadUnits.undead_witch_data.cost):
				#scene = undeadwitch_scene.instantiate()
			#else:
				#return
		#4: 
			#if _try_to_purchase(UndeadUnits.reaper_data.cost):
				#scene = reaper_scene.instantiate()
			#else:
				#return
		1: 
			if _try_to_purchase(DarknessUnits.shadowarcher_data.cost):
				scene = shadowarcher_scene.instantiate()
			else:
				return
		2: 
			if _try_to_purchase(DarknessUnits.nightborne_data.cost):
				scene = nightborne_scene.instantiate()
			else:
				return
		3: 
			if _try_to_purchase(DarknessUnits.darkknight_data.cost):
				scene = darkknight_scene.instantiate()
			else:
				return
		4: 
			if _try_to_purchase(DarknessUnits.doomsday_data.cost):
				scene = doomsday_scene.instantiate()
			else:
				return
		_: return
	LevelState.current_level.add_child(scene)
	scene.set_who(Global.Who.ENEMY)
	
