extends "res://entities/bullets/scripts/bullet.gd"

################################################################################
# PRIVATE METHODS
################################################################################

func _explode():
	_velocity = Vector2()
	_collision.set_deferred('disabled', true)
	_sprite.hide()
	_explosion.show()
	_explosion.play('clink')
