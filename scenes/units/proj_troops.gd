class_name ProjTroops extends BaseTroops

var _projectile_scene
var _proj_owner

var _proj_range: int

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
	_set_proj_range()
	projectile_instance.init(_proj_owner)

# find the closest target if parabola; if linear then just set to max distance
func _set_proj_range() -> void:
	#_proj_range = how far it flies; max distance
	#_proj_range = abs(target.global_position.x - proj_owner.global_position.x)
	_proj_range = 1

func set_proj_owner(proj_owner) -> void:
	_proj_owner = proj_owner
