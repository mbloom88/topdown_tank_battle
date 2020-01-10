extends HBoxContainer

# Child nodes
onready var _bar = $CenterContainer/Bar

################################################################################
# PUBLIC METHODS
################################################################################

func update_health(value):
	_bar.value = value

#-------------------------------------------------------------------------------

func update_max_health(value):
	_bar.max_value = value

################################################################################
# SIGNAL HANDLING
################################################################################

func _on_PlayerTank_health_changed(health, max_health):
	update_health(health)
	update_max_health(max_health)
