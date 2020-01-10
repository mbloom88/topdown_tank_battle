extends "res://entities/tanks/scripts/tank.gd"

# Parent nodes
onready var _parent = get_parent()

# Child nodes
onready var _player_detect_collision = $PlayerDetection/CollisionShape2D

# Turret
export (float) var detection_radius = 0.0
export (float) var rotation_speed = 0.0
var _target = null

################################################################################
# BUILT-IN VIRTUAL METHODS (CANNOT OVERRIDE)
################################################################################

func _ready():
	_player_detect_collision.shape.radius = detection_radius

################################################################################
# PRIVATE METHODS
################################################################################

func _detect_controls(delta):
	if _parent is PathFollow2D:
		_parent.set_offset(_parent.get_offset() + _max_speed * delta)
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

func _steer_turret(delta):
	var current_dir = Vector2(1, 0).rotated(_turret_pivot.global_rotation)
	if _target:
		var target_dir = (_target.position - global_position).normalized()
		_turret_pivot.global_rotation = current_dir.linear_interpolate(
			target_dir,
			rotation_speed * delta).angle()
	else:
		var body_dir = Vector2(cos(global_rotation), sin(global_rotation))
		_turret_pivot.global_rotation = current_dir.linear_interpolate(
			body_dir,
			rotation_speed * delta).angle()

################################################################################
# SIGNAL HANDLING
################################################################################

func _on_PlayerDetection_body_entered(body):
		_target = body

#-------------------------------------------------------------------------------

func _on_PlayerDetection_body_exited(body):
		_target = null
