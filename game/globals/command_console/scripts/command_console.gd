"""
Global command console for the game. 

WARNING: Running this script independently with F6 has undesirable effects.
Recommended to run this script inside a test scenee.
"""
extends CanvasLayer

# Child nodes
onready var _console = $ConsolePanel
onready var _scroll = $ConsolePanel/VBoxContainer/ScrollContainer
onready var _command_log = \
	$ConsolePanel/VBoxContainer/ScrollContainer/CommandLog
onready var _prompt = $ConsolePanel/VBoxContainer/Prompt

# Command prompt
var _is_activated = false

# Prompt entry 
var _entry_history = []
var _pointer = null

# Scenes
var _scene_focus = null

################################################################################
# BUILT-IN VIRTUAL METHODS (CANNOT OVERRIDE)
################################################################################

func _input(event):
	_check_inputs(event)

#-------------------------------------------------------------------------------

func _ready():
	_initialize_command_prompt()
	_deactivate()

################################################################################
# VIRTUAL METHODS
################################################################################

func _activate():
	_prompt.focus_mode = Control.FOCUS_ALL
	
	# Determine which focus object to return focus to when exiting
	for node in get_tree().get_nodes_in_group("focus_objects"):
		if node.get_focus_owner():
			_scene_focus = node.get_focus_owner()
			break

	_prompt.grab_focus()
	_scroll_log_down()
	get_tree().paused = true
	_console.visible = true

#-------------------------------------------------------------------------------

func _check_inputs(event):
	if event is InputEventKey:
		if event.scancode == KEY_QUOTELEFT and not event.is_pressed():
			_is_activated = !_is_activated
			match _is_activated:
				true:
					_activate()
				false:
					_deactivate()
			return
		
		if _is_activated:
			if event.scancode == KEY_UP and not event.is_pressed():
				if _pointer == null:
					return
				elif _pointer == 0:
					_pointer = (_entry_history.size() - 1)
				else:
					_pointer -= 1
				_prompt.text = _entry_history[_pointer]
			elif event.scancode == KEY_DOWN and not event.is_pressed():
				if _pointer == null:
					return
				elif _pointer == _entry_history.size() - 1:
					_pointer = 0
				else:
					_pointer += 1
				_prompt.text = _entry_history[_pointer]

#-------------------------------------------------------------------------------

func _deactivate():
	get_tree().paused = false
	_console.visible = false
	_prompt.focus_mode = Control.FOCUS_NONE
	_prompt.clear()
	
	if _scene_focus:
		_scene_focus.grab_focus()
		_scene_focus = null

#-------------------------------------------------------------------------------

func _initialize_command_prompt():
	_command_log.text = ""
	_prompt.clear()
	
	var text = "%s v%s" % [Utils.game_name(), Utils.game_version()]
	update_command_log(text)
	text = "Godot v%s" % Utils.godot_version()
	update_command_log(text)

#-------------------------------------------------------------------------------

func _scroll_log_down():
	yield(get_tree().create_timer(0.005), "timeout")
	var vscroll_max = _scroll.get_v_scrollbar().max_value
	_scroll.scroll_vertical = vscroll_max

################################################################################
# PUBLIC METHODS
################################################################################

func add_command_log_split():
	var current_history = _command_log.text
	var split = "--------------------------------------------------"
	_command_log.text = current_history + "\n" + split

#-------------------------------------------------------------------------------

func update_command_log(log_text):
	var current_history = _command_log.text
	var datetime = Utils.datetime()
	var new_log_text = datetime + ": " + log_text 
	
	add_command_log_split()
	_command_log.text = current_history + "\n" + new_log_text

################################################################################
# SIGNAL HANDLING
################################################################################

func _on_Prompt_text_changed(new_text):
	if new_text == "`":
		_prompt.clear()

#-------------------------------------------------------------------------------

func _on_Prompt_text_entered(new_text):
	"""
	Takes text that is entered into the command prompt to determine the 
	appropriate global command.
	
	# Args
		- new_text (str): text entered by the user.
	"""
	_entry_history.append(new_text)
	_pointer = _entry_history.size() - 1
	var current_history = _command_log.text
	var command = new_text.split(" ")
	var fields = command.size()
	var datetime = Utils.datetime()
	var new_log_text = datetime + ": " + "Invalid command received."
	
	match command[0]:
		'debug_mode':
			match command[1]:
				'activate':
					get_tree().call_group("debug", "activate_debug_mode")
					new_log_text = datetime + ": " + "Debug mode activated."
				'deactivate':
					get_tree().call_group("debug", "deactivate_debug_mode")
					new_log_text = datetime + ": " + "Debug mode deactivated."
		
	_command_log.text = current_history + "\n" + new_log_text
	_prompt.clear()
	_scroll_log_down()
