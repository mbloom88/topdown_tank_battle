extends "res://entities/bullets/scripts/bullet.gd"

# Child nodes
onready var _rocket_trail = $RocketTrail

################################################################################
# PRIVATE METHODS
################################################################################

func _explode():
	_target = null
	_velocity = Vector2()
	_collision.set_deferred('disabled', true)
	_rocket_trail.hide()
	_sprite.hide()
	_explosion.show()
	_explosion.play('smoke')
