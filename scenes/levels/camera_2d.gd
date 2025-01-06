extends Camera2D

@onready var _map = get_parent().get_node("Background")

@export var camera_speed: float = 350.0  # Adjust speed as needed
@export var screen_margin: float = 150.0  # Distance from screen edge to trigger movement

var _camera_offset: int = 0

func _ready() -> void:
	_restrict_player_camera()

func _process(delta: float) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var viewport_size = get_viewport().get_visible_rect().size
	var movement = Vector2.ZERO
	
	# Check right side of screen
	if mouse_pos.x > viewport_size.x - screen_margin:
		movement.x += 1
	# Check left side of screen
	if mouse_pos.x < screen_margin:
		movement.x -= 1
	## Check bottom of screen
	#if mouse_pos.y > viewport_size.y - screen_margin:
		#movement.y += 1
	## Check top of screen
	#if mouse_pos.y < screen_margin:
		#movement.y -= 1
		
	# Apply movement
	position += movement.normalized() * camera_speed * delta

func _restrict_player_camera() -> void:
	var rect: Rect2 = Utils.get_global_bounds(_map)
	var left = rect.position.x
	var top = rect.position.y
	var right = rect.position.x + rect.size.x
	var bottom = rect.position.y + rect.size.y
	_set_camera_limit(top, bottom, left, right)

func _set_camera_limit(top, bottom, left, right) -> void:
	limit_left = left - _camera_offset
	limit_top = top - _camera_offset
	limit_right = right + _camera_offset
	limit_bottom = bottom + _camera_offset
