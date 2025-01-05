class_name FarthestTargetProjTroops extends ProjTroops

@onready var _atk_range_box = _sprite.get_node("AtkRangeBoxArea")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_init_stats()
	_init_timers()
	_init_collisions()
	_init_misc()
	_connect_signals()

func _init_collisions() -> void:
	super()
	_atk_range_box.collision_layer = Global.Collision.DETECT_ONLY

func _set_ally() -> void:
	_atk_range_box.collision_mask = Global.Collision.ENEMY_UNIT | Global.Collision.ENEMY_BASE
	super()

func _set_enemy() -> void:
	_atk_range_box.collision_mask = Global.Collision.PLAYER_UNIT | Global.Collision.PLAYER_BASE
	super()

func _get_enemies_in_range() -> Array:
	var valid_enemies = []
	for area in _atk_range_box.get_overlapping_areas():
		if !is_instance_valid(area):
			continue
			
		var enemy_node = area.get_parent().get_parent()
		if is_instance_valid(enemy_node):
			if enemy_node._is_valid():
				valid_enemies.append(enemy_node)
	return valid_enemies
