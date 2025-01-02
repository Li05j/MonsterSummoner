class_name ProjTroops extends BaseTroops

var _projectile_scene
var _atk_range: int = 1
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
	projectile_instance.init(self)

# find the closest target if parabola; if linear then just set to max distance
func _set_proj_range() -> void:
	pass

###########################################################
##### Projectile Max Distance #####
###########################################################

# TODO: can just put this in init so we dont have to assign on every attack
func _by_fixed_range() -> void:
	_proj_range = _atk_range

func _by_closest_target() -> void:
	var valid_enemies = []
	for area in _atk_detect_box.get_overlapping_areas():
		if !is_instance_valid(area):
			continue
			
		var enemy_node = area.get_parent().get_parent()
		if is_instance_valid(enemy_node):
			if enemy_node._is_valid():
				valid_enemies.append(enemy_node)
	
	if valid_enemies.size() == 0:
		_proj_range = _atk_range
		
	valid_enemies.sort_custom(
		func(a, b): 
			return a.global_position.x < b.global_position.x
	)
	
	_proj_range = abs(valid_enemies[0].global_position.x - self.global_position.x)
