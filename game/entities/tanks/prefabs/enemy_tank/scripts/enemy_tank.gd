extends "res://entities/tanks/scripts/tank.gd"

# Parent nodes
onready var _parent = get_parent()

# Child nodes
onready var _player_detect_collision = $PlayerDetection/CollisionShape2D
onready var _front_collision_a = $FrontCollisionA
onready var _front_collision_b = $FrontCollisionB

# Turret
export (float) var _detection_radius = 0.0
export (float) var _turret_rotation_speed = 0.0
var _target = null

################################################################################
# BUILT-IN VIRTUAL METHODS (CANNOT OVERRIDE)
################################################################################

func _ready():
	_initialize_player_detection()

################################################################################
# PRIVATE METHODS
################################################################################

func _detect_controls(delta):
	# Braking
	if _front_collision_a.is_colliding() or _front_collision_b.is_colliding():
		_speed = lerp(_speed, 0, 0.1) # ramp speed down to 0
	else:
		_speed = lerp(_speed, max_speed, 0.05) # ramp speed up to max
	
	# Patrol pathing
	if _parent is PathFollow2D:
		_parent.set_offset(_parent.get_offset() + _speed * delta)
		"""
		Ensure tank is always centered at parent PathFollow2D's current offset
		position. If the tank collides with another object and it's position
		isn't constantly centered to the parent, the tank will become offset
		to the parent PathFollow2D's offset and weird movement effects will
		occur.
		"""
		position = Vector2() 
	else:
		pass

#-------------------------------------------------------------------------------

func _initialize_player_detection():
	var circle = CircleShape2D.new()
	_player_detect_collision.shape = circle
	_player_detect_collision.shape.radius = _detection_radius

#-------------------------------------------------------------------------------

func _steer_turret(delta):
	var current_dir = Vector2(1, 0).rotated(_turret_pivot.global_rotation)
	
	if _target:
		var target_dir = (_target.position - global_position).normalized()
		_turret_pivot.global_rotation = current_dir.linear_interpolate(
			target_dir,
			_turret_rotation_speed * delta).angle()
		if target_dir.dot(current_dir) > 0.9:
			_shoot_shell()
	else:
		var body_dir = Vector2(cos(global_rotation), sin(global_rotation))
		_turret_pivot.global_rotation = current_dir.linear_interpolate(
			body_dir,
			_turret_rotation_speed * delta).angle()

################################################################################
# SIGNAL HANDLING
################################################################################

func _on_PlayerDetection_body_entered(body):
		_target = body

#-------------------------------------------------------------------------------

func _on_PlayerDetection_body_exited(body):
		_target = null
