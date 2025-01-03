class_name ShadowArcherProj extends Projectile

func _ready() -> void:
	super()
	_offset_x = 32
	_offset_y = -39
	_travel_time = 1.0

func _set_initial_velocity() -> void:
	_linear()
