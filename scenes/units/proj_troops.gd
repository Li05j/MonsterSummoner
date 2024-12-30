class_name ProjTroops extends BaseTroops

var _projectile_scene
var _proj_owner

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_init_stats()
	_init_timers()
	_init_collisions()
	_init_misc()
	_connect_signals()

func _resolve_attack() -> void:
	var projectile_instance: Projectile = _projectile_scene.instantiate()
	LevelState.current_level.add_child(projectile_instance)
	projectile_instance.init(_proj_owner)

func set_proj_owner(proj_owner) -> void:
	_proj_owner = proj_owner
