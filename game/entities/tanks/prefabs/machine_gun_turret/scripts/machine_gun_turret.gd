extends "res://entities/tanks/prefabs/enemy_tank/scripts/enemy_tank.gd"

################################################################################
# PRIVATE METHODS
################################################################################

func _steer_turret(delta):
	var current_dir = Vector2(1, 0).rotated(_turret_pivot.global_rotation)
	
	if _target:
		var target_dir = (_target.position - global_position).normalized()
		
		_turret_pivot.global_rotation = current_dir.linear_interpolate(
			target_dir, _turret_rotation_speed * delta).angle()
		
		_is_in_los = _check_line_of_sight()
		
		if target_dir.dot(current_dir) > 0.95 and _is_in_los:
			_shoot_shell()
