class_name RangerProj extends Projectile

func _ready() -> void:
	super()
	_offset_x = 32
	_offset_y = -50
	_travel_time = 0.75

func _set_initial_velocity() -> void:
	_linear()

func _resolve_contact(other: Area2D) -> void:
	if is_instance_valid(other):
		var enemy = other.get_parent().get_parent()
		if is_instance_valid(enemy) and enemy._is_valid():
			var rate = 1
			if _proj_owner.shots >= _proj_owner.crit_shots:
				_proj_owner.shots -= _proj_owner.crit_shots
				rate = 4
			_proj_owner._deal_dmg(enemy, rate)
			
			_dead()
