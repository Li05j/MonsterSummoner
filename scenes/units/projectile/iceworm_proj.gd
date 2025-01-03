class_name IcewormProj extends Projectile

func _ready() -> void:
	super()
	_offset_x = 34
	_offset_y = -40
	_travel_time = 2.0

func _set_initial_velocity() -> void:
	_linear()
