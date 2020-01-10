extends Area2D

# Child nodes
onready var _lifetime = $Lifetime

# Bullet
export (float) var speed = 0.0
export (float) var damage = 0.0
export (float) var bullet_duration = 0.0
var _velocity = Vector2()

################################################################################
# BUILT-IN VIRTUAL METHODS (CANNOT OVERRIDE)
################################################################################

func _physics_process(delta):
	position += _velocity * delta

################################################################################
# PUBLIC METHODS
################################################################################

func explode():
	queue_free()

#-------------------------------------------------------------------------------

func start(spawn, direction):
	"""
	Args:
		- spawn (Vector2): Location to spawn the bullet in.
		- direction (Vector2): Direction the bullet should travel.
	"""
	position = spawn
	rotation_degrees = rad2deg(direction.angle())
	_lifetime.wait_time = bullet_duration
	_velocity = direction * speed

################################################################################
# SIGNAL HANDLING
################################################################################

func _on_Bullet_body_entered(body):
	explode()
	if body.has_method('take_damage'):
		body.take_damage(damage)

#-------------------------------------------------------------------------------

func _on_Lifetime_timeout():
	explode()
