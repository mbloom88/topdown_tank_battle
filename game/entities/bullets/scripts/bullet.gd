extends Area2D

# Child nodes
onready var _sprite = $Sprite
onready var _explosion = $Explosion
onready var _collision = $CollisionShape2D
onready var _lifetime = $Lifetime

# Bullet
export (float) var speed = 0.0
export (float) var damage = 0.0
export (float) var bullet_duration = 0.0
var _velocity = Vector2()

# Seeking
export (float) var steer_force = 0
var _acceleration = Vector2()
var _target = null

################################################################################
# BUILT-IN VIRTUAL METHODS (CANNOT OVERRIDE)
################################################################################

func _physics_process(delta):
	if _target:
		_acceleration += _seek()
		_velocity += _acceleration * delta
		_velocity = _velocity.clamped(speed)
		rotation_degrees = rad2deg(_velocity.angle())
	
	position += _velocity * delta

################################################################################
# PRIVATE METHODS
################################################################################

func _explode():
	_sprite.hide()
	_target = null
	_velocity = Vector2()
	_collision.set_deferred('disabled', true)
	_explosion.show()
	_explosion.play('smoke')

#-------------------------------------------------------------------------------

func _seek():
	var desired = (_target.position - position).normalized() * speed
	var steer = (desired - _velocity).normalized() * steer_force
    
	return steer

################################################################################
# PUBLIC METHODS
################################################################################

func start(spawn, direction, target=null):
	"""
	Args:
		- spawn (Vector2): Location to spawn the bullet in.
		- direction (Vector2): Direction the bullet should travel.
	"""
	position = spawn
	rotation_degrees = rad2deg(direction.angle())
	_velocity = direction * speed
	_target = target
	
	_lifetime.wait_time = bullet_duration
	_lifetime.start()

################################################################################
# SIGNAL HANDLING
################################################################################

func _on_Bullet_body_entered(body):
	if body.has_method('take_damage'):
		body.take_damage(damage)
	
	_explode()

#-------------------------------------------------------------------------------

func _on_Explosion_animation_finished():
	queue_free()

#-------------------------------------------------------------------------------

func _on_Lifetime_timeout():
	_explode()
