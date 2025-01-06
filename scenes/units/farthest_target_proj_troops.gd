class_name FarthestTargetProjTroops extends ProjTroops

@onready var _atk_range_box = _sprite.get_node("AtkRangeBoxArea")

var target_enemy_node

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

func _by_distance(closest: bool) -> void:
	var valid_enemies = _get_enemies_in_box(_atk_range_box)
	valid_enemies.sort_custom(
		func(a, b):
			var sort_way: bool = closest if _who == Global.Who.ALLY else !closest
			return a.global_position.x < b.global_position.x if sort_way else a.global_position.x > b.global_position.x
	)
	if valid_enemies.size():
		var first = valid_enemies[0]
		if !closest and (first is AllyBase or first is EnemyBase):
			# If farthest, base has lowest prio
			first = valid_enemies.pop_front()
			valid_enemies.push_back(first)
		_proj_range = abs(valid_enemies[0].global_position.x - global_position.x)
		target_enemy_node = valid_enemies[0]
	else:
		_proj_range = _max_travel_range
