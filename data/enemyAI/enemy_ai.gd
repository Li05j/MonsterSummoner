class_name EnemyAI extends Node

var last_check_time: float = 0.0

var goblin_scene = preload(Paths.MONSTER + "goblin.tscn")
var slime_scene = preload(Paths.MONSTER + "slime.tscn")
var fireworm_scene = preload(Paths.MONSTER + "fireworm.tscn")
var giant_scene = preload(Paths.MONSTER + "giant.tscn")

var shadowarcher_scene = preload(Paths.DARKNESS + "shadowarcher.tscn")
var nightborne_scene = preload(Paths.DARKNESS + "nightborne.tscn")

func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if LevelState.game_time - last_check_time >= 2.0:
		last_check_time = LevelState.game_time
		last_check_time = INF
		summon()

func summon() -> void:
	#var scene = goblin_scene.instantiate()
	#var scene = slime_scene.instantiate()
	#var scene = fireworm_scene.instantiate()
	#var scene = giant_scene.instantiate()
	
	var scene = shadowarcher_scene.instantiate()
	#var scene = nightborne_scene.instantiate()
	LevelState.current_level.add_child(scene)
	scene.set_who(Types.Who.ENEMY)
	
