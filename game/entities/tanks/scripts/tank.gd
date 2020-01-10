extends KinematicBody2D

# Signals
signal dead
signal health_changed

# Child nodes
onready var _turret_pivot = $TurretPivot
onready var _cannon_cooldown = $CannonCooldown

# Tank
export (int) var _max_health = 0
var _is_alive = true

# Turret
export (PackedScene) var _cannon_shell
export (float) var _cannon_fire_cooldown = 0.0
var _can_shoot = true

# Movement
export (float) var _max_speed = 0.0
export (float) var _rotation_speed = 0.0
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
	_cannon_cooldown.wait_time = _cannon_fire_cooldown

################################################################################
# PRIVATE METHODS
################################################################################

func _detect_controls(delta):
	pass

#-------------------------------------------------------------------------------

func _steer_turret(delta):
	pass
