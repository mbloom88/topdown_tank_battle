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

# Obstacle detection
var _hits = []
var _target = null
var _is_in_los = false
var _aim_location = Vector2()

# Debug
var _is_debugging = false

################################################################################
# BUILT-IN VIRTUAL METHODS (CANNOT OVERRIDE)
################################################################################

func _draw():
	if not _is_debugging:
		return
	
	# Draw detection circle
	draw_circle(Vector2(), _detection_radius, Color(.867, .91, .247, 0.25))
	
	# Pointing line to target
	if _target:
		for hit in _hits:
			var hit_vector = (hit - global_position).rotated(-global_rotation)
			draw_line(Vector2(), hit_vector, Color.red)
			draw_circle(hit_vector, 5, Color.red)

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
	
	# Add five sight lines to the edges of the targets collision shape and to
	# its center
	_hits.clear()
	_is_in_los = false
	
	var target_extents = \
		_target.get_node('CollisionShape2D').shape.extents - Vector2(5, 5)
	var nw = _target.position - target_extents
	var se = _target.position + target_extents
	var ne = _target.position + Vector2(target_extents.x, -target_extents.y)
	var sw = _target.position + Vector2(-target_extents.x, target_extents.y)
	
	for pos in [_target.position, nw, ne, se, sw]:
		var new_obstacle = space.intersect_ray(global_position, pos, [self],
			collision_mask)
		
		if not new_obstacle:
			continue
		
		_hits.append(new_obstacle.position)
		
		if new_obstacle.collider == _target:
			_is_in_los = true
			_aim_location = new_obstacle.position
			break

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
		_check_line_of_sight()
		
		if _is_in_los:
			var target_dir = (_aim_location - global_position).normalized()
	
			_turret_pivot.global_rotation = current_dir.linear_interpolate(
				target_dir, _turret_rotation_speed * delta).angle()
			
			if target_dir.dot(current_dir) > 0.95:
				_shoot_shell(_target)
		else:
			var body_dir = Vector2(cos(global_rotation), sin(global_rotation))
		
			_turret_pivot.global_rotation = current_dir.linear_interpolate(
				body_dir, _turret_rotation_speed * delta).angle()
	else:
		var body_dir = Vector2(cos(global_rotation), sin(global_rotation))
		
		_turret_pivot.global_rotation = current_dir.linear_interpolate(
			body_dir, _turret_rotation_speed * delta).angle()

################################################################################
# PUBLIC METHODS
################################################################################

func activate_debug_mode():
	_is_debugging = true
	update()

#-------------------------------------------------------------------------------

func deactivate_debug_mode():
	_is_debugging = false

################################################################################
# SIGNAL HANDLING
################################################################################

func _on_PlayerDetection_body_entered(body):
	_target = body

#-------------------------------------------------------------------------------

func _on_PlayerDetection_body_exited(body):
	_target = null
