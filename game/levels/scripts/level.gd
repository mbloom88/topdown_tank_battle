extends Node2D

# Child nodes
onready var _ground = $Ground
onready var _player = $PlayerTank
onready var _bullets = $Bullets

# Mouse
export (Resource) var mouse_cursor

################################################################################
# BUILT-IN VIRTUAL METHODS (CANNOT OVERRIDE)
################################################################################

func _ready():
	_set_camera_limits()
	_set_mouse_cursor()
	_connect_tanks()
	_player.update_health_hud()

################################################################################
# PRIVATE METHODS
################################################################################

func _connect_tanks():
	var tanks = get_tree().get_nodes_in_group('tanks')
	for tank in tanks:
		tank.connect('bullet_fired', self, '_on_Tank_bullet_fired')

#-------------------------------------------------------------------------------

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

#-------------------------------------------------------------------------------

func _set_mouse_cursor():
	var hotspot = Vector2(32, 32) # Cursor’s detection point
	Input.set_custom_mouse_cursor(mouse_cursor, Input.CURSOR_ARROW, 
		hotspot)

################################################################################
# SIGNLA HANDLING
################################################################################

func _on_Tank_bullet_fired(bullet, spawn, direction, target=null):
	var b = bullet.instance()
	_bullets.add_child(b)
	b.start(spawn, direction, target)
