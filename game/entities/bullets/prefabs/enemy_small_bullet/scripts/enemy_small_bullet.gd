extends "res://entities/bullets/scripts/bullet.gd"

################################################################################
# PRIVATE METHODS
################################################################################

func _explode():
	_sprite.hide()
	_velocity = Vector2()
	_collision.set_deferred('disabled', true)
	_explosion.show()
	_explosion.play('clink')
