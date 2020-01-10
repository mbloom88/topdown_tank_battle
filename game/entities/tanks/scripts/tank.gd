extends KinematicBody2D

# Signals
signal dead
signal bullet_fired(bullet, spawn, direction)
signal health_changed(health, max_health)

# Child nodes
onready var _turret_pivot = $TurretPivot
onready var _muzzle_point = $TurretPivot/Turret/MuzzlePoint
onready var _shell_cooldown = $ShellCooldown

# Tank
export (int) var max_health = 0
var _health = 0
var _is_alive = true

# Turret
export (PackedScene) var _shell
export (float) var _shell_cooldown_value = 0.0

# Movement
export (float) var max_speed = 0.0
export (float) var _body_rotation_speed = 0.0
var _speed = 0
var _velocity = Vector2()

################################################################################
# BUILT-IN VIRTUAL METHODS (CANNOT OVERRIDE)
################################################################################

func _physics_process(delta):
	if not _is_alive:
		return
	
	_detect_controls(delta)
	_steer_turret(delta)
	move_and_slide(_velocity)

#-------------------------------------------------------------------------------

func _ready():
	_health = max_health
	_shell_cooldown.wait_time = _shell_cooldown_value

################################################################################
# PRIVATE METHODS
################################################################################

func _detect_controls(delta):
	"""
	Overwrite method in inheriting script.
	"""
	pass

#-------------------------------------------------------------------------------

func _explode():
	queue_free()

#-------------------------------------------------------------------------------

func _shoot_shell():
	if _shell_cooldown.is_stopped():
		_shell_cooldown.start()
		var spawn = _muzzle_point.global_position
		var dir = Vector2(1, 0).rotated(_turret_pivot.global_rotation)
		emit_signal('bullet_fired', _shell, spawn, dir)

#-------------------------------------------------------------------------------

func _steer_turret(delta):
	"""
	Overwrite method in inheriting script.
	"""

################################################################################
# PUBLIC METHODS
################################################################################

func take_damage(amount):
	_health -= amount
	emit_signal('health_changed', _health, max_health)
	
	if _health <= 0:
		_explode()
