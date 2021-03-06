extends "res://entities/tanks/scripts/tank.gd"

# Child nodes
onready var _camera = $Camera2D

################################################################################
# PRIVATE METHODS
################################################################################

func _detect_controls(delta):
	_turret_pivot.look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed('shoot_shell'):
		_shoot_shell()
	
	if Input.is_action_pressed('turn_left'):
		rotation_degrees -= _body_rotation_speed * delta
	elif Input.is_action_pressed('turn_right'):
		rotation_degrees += _body_rotation_speed * delta
	
	if Input.is_action_pressed('forward'):
		_velocity = Vector2(max_speed, 0).rotated(deg2rad(rotation_degrees))
	elif Input.is_action_pressed('reverse'):
		_velocity = \
			Vector2(-max_speed / 2, 0).rotated(deg2rad(rotation_degrees))
	else:
		_velocity = Vector2()

################################################################################
# PUBLIC METHODS
################################################################################

func heal(amount):
	_health += amount
	
	if _health > max_health:
		_health = max_health
	
	update_health_hud()

#-------------------------------------------------------------------------------

func set_camera_limits(limits):
	_camera.limit_left = limits['left']
	_camera.limit_right = limits['right']
	_camera.limit_top = limits['top']
	_camera.limit_bottom = limits['bottom']

#-------------------------------------------------------------------------------

func update_health_hud():
	emit_signal('health_changed', _health, max_health)
