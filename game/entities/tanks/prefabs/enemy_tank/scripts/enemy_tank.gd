extends "res://entities/tanks/scripts/tank.gd"

# Parent nodes
onready var _parent = get_parent()

# Child nodes
onready var _player_detect_collision = $PlayerDetection/CollisionShape2D
onready var _front_collision_a = $FrontCollisionA
onready var _front_collision_b = $FrontCollisionB
onready var _unit_display = $UnitDisplay

# Turret
export (float) var _detection_radius = 0.0
export (float) var _turret_rotation_speed = 0.0
var _target = null
var _obstacle = null
var _is_in_los = false

################################################################################
# BUILT-IN VIRTUAL METHODS (CANNOT OVERRIDE)
################################################################################

func _draw():
	if _target:
		draw_line(Vector2(), _obstacle.position - position, Color.red)

#-------------------------------------------------------------------------------

func _physics_process(delta):
	update()

#-------------------------------------------------------------------------------

func _ready():
	_initialize_player_detection()
	emit_signal('health_changed', _health, max_health)

################################################################################
# PRIVATE METHODS
################################################################################

func _check_line_of_sight():
	"""
	Checks to see if the target is within line of sight (LOS).
	
	Returns true if target is in LOS.
	"""
	var space = get_world_2d().direct_space_state
	
	var new_obstacle = space.intersect_ray(
		global_position, _target.global_position, [self], collision_mask)
	
	# Error checking
	if not new_obstacle:
		_obstacle = null
		return false
	
	_obstacle = new_obstacle.collider
	
	if new_obstacle.collider == _target:
		return true
	else:
		return false

#-------------------------------------------------------------------------------

func _detect_controls(delta):
	if _parent is PathFollow2D:
		# Braking
		if _front_collision_a.is_colliding() or \
			_front_collision_b.is_colliding():
			_speed = lerp(_speed, 0, 0.1) # ramp speed down to 0
		else:
			_speed = lerp(_speed, max_speed, 0.05) # ramp speed up to max
		
		# Patrol pathing
		_parent.set_offset(_parent.get_offset() + _speed * delta)
		"""
		Ensure tank is always centered at parent PathFollow2D's current offset
		position. If the tank collides with another object and it's position
		isn't constantly centered to the parent, the tank will become offset
		to the parent PathFollow2D's offset and weird movement effects will
		occur.
		"""
		position = Vector2() 

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
			target_dir, _turret_rotation_speed * delta).angle()
		
		_is_in_los = _check_line_of_sight()
		
		if target_dir.dot(current_dir) > 0.95 and _is_in_los:
			_shoot_shell(_target)
	else:
		var body_dir = Vector2(cos(global_rotation), sin(global_rotation))
		
		_turret_pivot.global_rotation = current_dir.linear_interpolate(
			body_dir, _turret_rotation_speed * delta).angle()

################################################################################
# SIGNAL HANDLING
################################################################################

func _on_PlayerDetection_body_entered(body):
		if body.collision_layer == 1:
			_target = body

#-------------------------------------------------------------------------------

func _on_PlayerDetection_body_exited(body):
		if body.collision_layer == 1:
			_target = null
