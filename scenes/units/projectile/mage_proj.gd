class_name MageProj extends Projectile

func _init_misc() -> void:
	super()
	_offset_x = 34
	_offset_y = -55
	_travel_time = 1.5

func _set_initial_velocity() -> void:
	_linear()
