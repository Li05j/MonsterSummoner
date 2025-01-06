extends Camera2D

@onready var _map = get_parent().get_node("Bg")

@export var camera_speed: float = 500.0  # Adjust speed as needed
@export var screen_margin: float = 150.0  # Distance from screen edge to trigger movement

var _viewport_size
var _dir = 0
var _camera_offset: int = 0

var _bottom_margin_for_mouse = 530

func _ready() -> void:
	_restrict_player_camera()
	_viewport_size = get_viewport().get_visible_rect().size

func _process(delta: float) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	
	if mouse_pos.y > _bottom_margin_for_mouse:
		return
	
	# so that the camera doesnt wander into the void
	if position.x < limit_left:
		position.x = limit_left
	if position.x > limit_right - _viewport_size.x:
		position.x = limit_right - _viewport_size.x
		
	# Check right side of screen
	if mouse_pos.x > _viewport_size.x - screen_margin:
		_dir = 1
	# Check left side of screen
	elif mouse_pos.x < screen_margin:
		_dir = -1
	
	if Input.is_action_pressed("left"):
		_dir = -1
	elif Input.is_action_pressed("right"):
		_dir = 1
		
	## Check bottom of screen
	#if mouse_pos.y > viewport_size.y - screen_margin:
		#movement.y += 1
	## Check top of screen
	#if mouse_pos.y < screen_margin:
		#movement.y -= 1
		
	# Apply movement
	#position += movement * camera_speed * delta
	position.x += _dir * camera_speed * delta
	_dir = 0 # reset

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
	
	print(limit_left)
	print(limit_top)
	print(limit_right)
	print(limit_bottom)
