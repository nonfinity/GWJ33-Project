extends Control

### ### ## ## ## ### ###
### VARIABLES GALORE ###
### ### ## ## ## ### ###
signal read_out_finished

var speaker: String = "#"		setget _set_speaker
var dialog: String = "#"	setget _set_dialog

onready var tween = $ShowTextTween
onready var bgPanel = $Panel
onready var chat_text = $VBoxContainer/ChatText
onready var nameTag = $VBoxContainer/NameTag


var _is_ready: bool = false
var _read_out_time := 0.5

var theme_paths := {
	"hero_palmer": "res://styling/themes/hero_palmer.tres",
	"hero_jackson": "res://styling/themes/hero_jackson.tres",
	"hero_chandler": "res://styling/themes/hero_chandler.tres",
	"hero_brodie": "res://styling/themes/hero_brodie.tres",
	"clerk_dialog": "res://styling/themes/clerk_dialog.tres",
	"clerk_internal": "res://styling/themes/clerk_internal.tres",
	"client_standard": "res://styling/themes/client_standard.tres",
	"client_intrenhall": "res://styling/themes/client_intrenhall.tres",
}


### ### ### ### ## ### ### ###
### CORE PROCESS FUNCTIONS ###
### ### ### ### ## ### ### ###

func _ready():
	pass

func _process(_delta):
	pass # Replace with function body.



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
func _check_for_ready() -> void:
	_is_ready = (speaker != "#") and (dialog != "#")

func do_formatting(by_customer: bool):
	var nameColor: Color = CharacterInterface.get_nameColor(by_customer)
	var bgColor: Color = CharacterInterface.get_textBgColor(by_customer)
	
	nameTag.set("custom_colors/font_color", nameColor)
	chat_text.set("custom_colors/default_color", nameColor.lightened(0.45))
	#$Panel.modulate = bgColor
	var s = bgPanel.get_stylebox("panel").duplicate()
	
	#s.bg_color = bgColor
	s.border_color = bgColor
	
	bgPanel.set("custom_styles/panel", s)
	pass

func assign_theme(which: String):
	var theme_key:= ""
	
	if which == "clerk":
		theme_key = "clerk_dialog"
	elif which == "thought":
		theme_key = "clerk_internal"
	else:
		theme_key = CharacterInterface.get_client_theme()
	
	theme = load(theme_paths[theme_key])

func read_out() -> void:
	tween.interpolate_property(chat_text, "percent_visible", 0.0, 1.0, _read_out_time)
	tween.start()
	
	yield(get_tree().create_timer(_read_out_time), "timeout")
	emit_signal("read_out_finished")

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
#	SETGET DEFINITIONS
#	Functions identified as setters or getters
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
func _set_speaker(value: String) -> void:
	speaker = value
	nameTag.text = speaker


func _set_dialog(value: String) -> void:
	dialog = value
	chat_text.bbcode_text = dialog
	_check_for_ready()


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




func _on_ChatText_resized():
	if is_instance_valid(chat_text):
		rect_min_size.y = 30 + chat_text.rect_size.y
