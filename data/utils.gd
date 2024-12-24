class_name Utils extends Resource

static func time_to_min_sec_msec(time: float) -> Dictionary:
	var time_without_dec: int = floor(time)
	var mins: int = floor(time_without_dec / 60.0)
	var secs: int = time_without_dec % 60
	var msecs: int = snapped((time - time_without_dec) * 100, 0.01)
	return {
		"min": mins,
		"sec": secs,
		"msec": msecs,
	}

static func format_time(time: float) -> String:
	var time_split = time_to_min_sec_msec(time)
	return "%02d:%02d:%02d" % [time_split.min, time_split.sec, time_split.msec]

static func normalize_radians(angle: float) -> float:
	while angle > PI:
		angle -= 2 * PI
	while angle < -PI:
		angle += 2 * PI
	return angle

static func get_global_bounds(node) -> Rect2:
	if node is Sprite2D:
		var size = Vector2(node.texture.get_width(), node.texture.get_height()) * node.scale
		var origin_offset = node.offset * node.scale
		var top_left = node.global_position - (size / 2) + origin_offset
		return Rect2(top_left, size)
	elif node is Control:
		return node.get_global_rect()
	else:
		return Rect2(Vector2(), Vector2())

static func get_global_center(node) -> Vector2:
	var bounds = get_global_bounds(node)
	return bounds.position + bounds.size / 2

#static func convert_animation_string_to_enum(str: String) -> Types_M.Animation_Type:
	#match str:
		#"idle":
			#return Types_M.Animation_Type.IDLE
		#"run":
			#return Types_M.Animation_Type.RUN
		#"attack":
			#return Types_M.Animation_Type.ATTACK
		#"special":
			#return Types_M.Animation_Type.SPECIAL
		#"hurt":
			#return Types_M.Animation_Type.HURT
		#"death":
			#return Types_M.Animation_Type.DEATH
		#_:
			#return Types_M.Animation_Type.NONE
