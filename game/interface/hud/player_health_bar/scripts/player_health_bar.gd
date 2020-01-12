extends HBoxContainer

# Child nodes
onready var _anim = $AnimationPlayer
onready var _tween = $Tween
onready var _bar = $CenterContainer/Bar

# Bar
export (Resource) var green_bar
export (Resource) var yellow_bar
export (int) var yellow_threshold_percentage = 0
export (Resource) var red_bar
export (int) var red_threshold_percentage = 0
var _bar_texture = null

################################################################################
# PUBLIC METHODS
################################################################################

func update_health(value):
	var has_been_damaged = false
	
	if value < _bar.value:
		has_been_damaged = true
	
	var health_percentage = value / _bar.max_value * 100
	var bar_texture = null
	
	if health_percentage > yellow_threshold_percentage:
		_bar_texture = green_bar
	if health_percentage <= yellow_threshold_percentage:
		_bar_texture = yellow_bar
	if health_percentage <= red_threshold_percentage:
		_bar_texture = red_bar
	
	_bar.texture_progress = _bar_texture
	
	_tween.interpolate_property(_bar, 'value', _bar.value, value, 0.2,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	_tween.start()
	
	if has_been_damaged:
		_anim.play('health_flash')

#-------------------------------------------------------------------------------

func update_max_health(value):
	_bar.max_value = value

################################################################################
# SIGNAL HANDLING
################################################################################

func _on_AnimationPlayer_animation_finished(anim_name):
	_bar.texture_progress = _bar_texture

#-------------------------------------------------------------------------------

func _on_PlayerTank_health_changed(health, max_health):
	update_max_health(max_health)
	update_health(health)
