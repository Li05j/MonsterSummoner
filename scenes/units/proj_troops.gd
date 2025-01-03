class_name ProjTroops extends BaseTroops

var _projectile_scene
var _max_travel_range: int = 1
var _proj_range: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_init_stats()
	_init_timers()
	_init_collisions()
	_init_misc()
	_connect_signals()

func _init_misc() -> void:
	super()
	_init_proj_max_range()

func _resolve_attack() -> void:
	var projectile_instance: Projectile = _projectile_scene.instantiate()
	LevelState.current_level.add_child(projectile_instance)
	_set_proj_range()
	projectile_instance.init(self)

func _init_proj_max_range() -> void:
	_max_travel_range = _atk_detect_box.get_child(0).shape.size.x * _sprite.scale.x # convert pixels to units
	_proj_range = _max_travel_range

# find the closest target if parabola; default is liunear - set to max range
func _set_proj_range() -> void:
	pass

func _get_detect_box_enemies_x() -> Array:
	var valid_enemies_x = []
	for area in _atk_detect_box.get_overlapping_areas():
		if !is_instance_valid(area):
			continue
			
		var enemy_node = area.get_parent().get_parent()
		if is_instance_valid(enemy_node):
			if enemy_node._is_valid():
				valid_enemies_x.append(enemy_node.global_position.x)
	return valid_enemies_x

###########################################################
##### Projectile Max Distance #####
###########################################################

#func _by_fixed_range() -> void:
	#_proj_range = _atk_detect_box.get_child(0).shape.size.x * _sprite.scale.x # convert pixels to units

func _by_distance(closest: bool) -> void:
	var valid_enemies_x = _get_detect_box_enemies_x()
	valid_enemies_x.sort_custom(
		func(a, b): 
			return a < b if closest else a > b
	)
	if valid_enemies_x.size():
		_proj_range = abs(valid_enemies_x[0] - self.global_position.x)
	else:
		_proj_range = _max_travel_range
