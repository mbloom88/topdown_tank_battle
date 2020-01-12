extends Node

################################################################################
# PUBLIC METHODS
################################################################################

func datetime():
	var time_dict =  OS.get_datetime()
	var yyyy = time_dict['year']
	var mm = time_dict['month']
	var dd = time_dict['day']
	var hours = ""
	var mins = ""
	var secs = ""
	
	if time_dict['hour'] < 10:
		hours = "0" + str(time_dict['hour'])
	else:
		hours = str(time_dict['hour'])
	
	if time_dict['minute'] < 10:
		mins = "0" + str(time_dict['minute'])
	else:
		mins = str(time_dict['minute'])
	
	if time_dict['second'] < 10:
		secs = "0" + str(time_dict['second'])
	else:
		secs = str(time_dict['second'])
	
	return "%s/%s/%s %s:%s:%s" % [yyyy, mm, dd, hours, mins, secs]

#-------------------------------------------------------------------------------

func display_height():
	return ProjectSettings.get_setting("display/window/size/height")

#-------------------------------------------------------------------------------

func display_width():
	return ProjectSettings.get_setting("display/window/size/width")

#-------------------------------------------------------------------------------

func game_name():
	return ProjectSettings.get_setting("application/config/name")

#-------------------------------------------------------------------------------

func game_version():
	return ProjectSettings.get_setting("application/config/game_version")

#-------------------------------------------------------------------------------

func godot_version():
	return ProjectSettings.get_setting("application/config/godot_version")
