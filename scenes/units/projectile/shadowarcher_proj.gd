class_name ShadowArcherProj extends Projectile

func _ready() -> void:
	super()
	_offset_x = 32
	_offset_y = -36
	_travel_time = 0.8

func _set_initial_velocity() -> void:
	_linear()
