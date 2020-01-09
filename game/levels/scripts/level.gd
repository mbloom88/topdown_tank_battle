extends Node2D

# Child nodes
onready var _ground = $Ground
onready var _player = $PlayerTank

################################################################################
# BUILT-IN VIRTUAL METHODS (CANNOT OVERRIDE)
################################################################################

func _ready():
	_set_camera_limits()

################################################################################
# PRIVATE
################################################################################

func _set_camera_limits():
	var map_limits = _ground.get_used_rect()
	var map_cell_size = _ground.cell_size
	var limits = {
		'left': map_limits.position.x * map_cell_size.x,
		'right': map_limits.end.x * map_cell_size.x,
		'top': map_limits.position.y * map_cell_size.y,
		'bottom': map_limits.end.y * map_cell_size.y,
	}
	_player.set_camera_limits(limits)
