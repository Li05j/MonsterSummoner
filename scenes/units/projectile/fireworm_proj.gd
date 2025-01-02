class_name FirewormProj extends Projectile

func _ready() -> void:
	super()
	_offset_x = 32
	_offset_y = -36
	_travel_time = 2.0

func _set_initial_velocity() -> void:
	_linear()
