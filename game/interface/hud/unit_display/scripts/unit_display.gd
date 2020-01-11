extends Node2D

# Child nodes
onready var _tween = $Tween
onready var _health_bar = $HealthBar

# Bar
export (Resource) var green_bar
export (Resource) var yellow_bar
export (int) var yellow_threshold_percentage = 0
export (Resource) var red_bar
export (int) var red_threshold_percentage = 0
var _bar_texture = null

################################################################################
# BUILT-IN VIRTUAL METHODS (CANNOT OVERRIDE)
################################################################################

func _process(delta):
	global_rotation_degrees = 0 # keeps node locked in place

#-------------------------------------------------------------------------------

func _ready():
	_health_bar.hide()

################################################################################
# PUBLIC METHODS
################################################################################

func update_health(value):
	var health_percentage = value / _health_bar.max_value * 100
	var bar_texture = null
	
	if health_percentage < 100:
		_health_bar.show()
	
	if health_percentage > yellow_threshold_percentage:
		_bar_texture = green_bar
	if health_percentage <= yellow_threshold_percentage:
		_bar_texture = yellow_bar
	if health_percentage <= red_threshold_percentage:
		_bar_texture = red_bar
	
	_health_bar.texture_progress = _bar_texture
	
	_tween.interpolate_property(_health_bar, 'value', _health_bar.value, value,
		0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	_tween.start()

#-------------------------------------------------------------------------------

func update_max_health(value):
	_health_bar.max_value = value

################################################################################
# SIGNAL HANDLING
################################################################################

func _on_Unit_health_changed(health, max_health):
	update_max_health(max_health)
	update_health(health)
