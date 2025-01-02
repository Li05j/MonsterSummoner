class_name ProjTroops extends BaseTroops

var _projectile_scene
var _fallback_atk_range: int = 1
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

func _by_fixed_range() -> void:
	_proj_range = _atk_detect_box.get_child(0).shape.size.x * _sprite.scale.x # convert pixels to units

func _by_closest_target() -> void:
	_by_fixed_range()
	
	var valid_enemies_x = []
	for area in _atk_detect_box.get_overlapping_areas():
		if !is_instance_valid(area):
			continue
			
		var enemy_node = area.get_parent().get_parent()
		if is_instance_valid(enemy_node):
			if enemy_node._is_valid():
				valid_enemies_x.append(enemy_node.global_position.x)
	
	valid_enemies_x.sort_custom(
		func(a, b): 
			return a < b
	)
	
	if valid_enemies_x.size():
		_proj_range = abs(valid_enemies_x[0] - self.global_position.x)
