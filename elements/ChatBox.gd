extends Control

### ### ## ## ## ### ###
### VARIABLES GALORE ###
### ### ## ## ## ### ###
signal new_chat_line(dialog_type, by_customer)
signal chat_line_added
signal chat_core_done
signal scroll_updater_done

onready var chatline_master = preload("res://elements/TextLine.tscn")

onready var chat_parent = $ScrollContainer/VBoxContainer
onready var scroller = $ScrollContainer

### ### ### ### ## ### ### ###
### CORE PROCESS FUNCTIONS ###
### ### ### ### ## ### ### ###

func _ready():
	
	pass # Replace with function body.

func _process(_delta):
	#chat_parent.get_parent().scroll_vertical += 1
	pass



# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
#	CALCULATOR FUCNTIONS
#	These functions calculate things, but do not change values
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *



# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
#	MUTATOR FUCNTIONS
#	These functions change values
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
func _add_chat_core(set_dialog: String, source: String) -> void:
	var new_chat = chatline_master.instance()
	chat_parent.add_child(new_chat)
	
	var speaker: String
	match source:
		"client":
			speaker = CharacterInterface.get_name()
		"clerk":
			speaker = "You"
		"thought":
			speaker = "Mental Note"
		_:
			speaker = "ERROR: Unrecognized speaker"
	new_chat.speaker = speaker
	new_chat.dialog = set_dialog
	new_chat.assign_theme(source)
	new_chat.read_out()
	
	_scroll_updater()
	yield(self,"scroll_updater_done")
	yield(new_chat, "read_out_finished")
	
	yield(get_tree().create_timer(0.5), "timeout")
	emit_signal("chat_core_done")


func add_chat(set_dialog: String, source: String) -> void:
	_add_chat_core(set_dialog, source)
	
	yield(self,"chat_core_done")
	emit_signal("new_chat_line", -1, source)
	emit_signal("chat_line_added")

func add_custom_chat(speaker: String, dialog: String, theme: String) -> void:
	var new_chat = chatline_master.instance()
	chat_parent.add_child(new_chat)
	
	new_chat.speaker = speaker
	new_chat.dialog = dialog
	new_chat.assign_theme(theme)
	new_chat.read_out()
	
	_scroll_updater()
	yield(self,"scroll_updater_done")
	yield(new_chat, "read_out_finished")
	
	emit_signal("chat_line_added")
#
#func add_chat_line(set_dialog: String) -> void:
#	_add_chat_core(set_dialog, true)
#	emit_signal("new_chat_line", -1, true)
#
#
#func add_chat_by_type(ofType: int) -> void:
#	var dialog: String
#	dialog = CharacterInterface.get_dialog(ofType, true)
#
#	_add_chat_core(dialog, true)
#	emit_signal("new_chat_line", ofType, true)
#
#
#func add_clerk_dialog(set_dialog: String) -> void:
#	_add_chat_core(set_dialog, false)
#	emit_signal("new_chat_line", -1, false)
#
#
#func add_clerk_dialog_by_type(ofType: int) -> void:
#	var dialog: String
#	dialog = CharacterInterface.get_dialog(ofType, false)
#
#	_add_chat_core(dialog, false)
#	emit_signal("new_chat_line", ofType, false)

func _scroll_updater():
	yield(get_tree().create_timer(0.01), "timeout")
	var scroll_y: int = -1
	
	while scroll_y != scroller.scroll_vertical:
		scroll_y = scroller.scroll_vertical
		scroller.scroll_vertical += 1
	
	#scroller.scroll_vertical += which.rect_size.y
	scroller.update()
	emit_signal("scroll_updater_done")

func clear_chat_log() -> void:
	for c in chat_parent.get_children():
		c.queue_free()


# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
#	SETGET DEFINITIONS
#	Functions identified as setters or getters
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *



# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
#	ABSTRACT FUCNTIONS.
#	Child classes must define
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *

#func abstract_example(): 
#	assert(false, "Child classes must declare abstract_example()")



# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
#	INHERITED ABSTRACT FUNCTIONS
#	Parent class functions this child MUST override
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *



# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
#	PARENT OVERRIDE FUNCTIONS
#	Parent class functions this child optionally overrides
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *



# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
#	LISTENER FUNCTIONS
#	Functions connected to signals
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
