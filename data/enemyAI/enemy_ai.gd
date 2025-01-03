class_name EnemyAI extends Node

var last_check_time: float = 0.0

var goblin_scene = preload(Paths.MONSTER + "goblin.tscn")
var slime_scene = preload(Paths.MONSTER + "slime.tscn")
var iceworm_scene = preload(Paths.MONSTER + "iceworm.tscn")
var giant_scene = preload(Paths.MONSTER + "giant.tscn")

var shadowarcher_scene = preload(Paths.DARKNESS + "shadowarcher.tscn")
var nightborne_scene = preload(Paths.DARKNESS + "nightborne.tscn")
var darkknight_scene = preload(Paths.DARKNESS + "darkknight.tscn")
var doomsday_scene = preload(Paths.DARKNESS + "doomsday.tscn")

func _ready() -> void:
	summon()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if LevelState.game_time - last_check_time >= 1.5:
		last_check_time = LevelState.game_time
		last_check_time = INF
		summon()

func summon() -> void:
	var scene
	#scene = goblin_scene.instantiate()
	#scene = slime_scene.instantiate()
	#scene = iceworm_scene.instantiate()
	#scene = giant_scene.instantiate()
	
	#scene = shadowarcher_scene.instantiate()
	scene = nightborne_scene.instantiate()
	#scene = darkknight_scene.instantiate()
	#scene = doomsday_scene.instantiate()
	LevelState.current_level.add_child(scene)
	scene.set_who(Types.Who.ENEMY)
	
