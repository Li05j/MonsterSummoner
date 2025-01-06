class_name SlimeProj extends Projectile

func _ready() -> void:
	super()
	_offset_y = -15
	_travel_time = 2.85

func _set_initial_velocity() -> void:
	_parabola()
