extends Control

### ### ## ## ## ### ###
### VARIABLES GALORE ###
### ### ## ## ## ### ###
signal transition_done
signal begin_day
signal clear_chat_log
signal rooster_crow


### ### ### ### ## ### ### ###
### CORE PROCESS FUNCTIONS ###
### ### ### ### ## ### ### ###

func _ready():
	self.visible = false

	pass # Replace with function body.

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
func splash_first(set_score: Dictionary) -> void:
	self.visible = true
	#$AnimationPlayer.play("fade_to_black")
	
	var headline = "New Pawn Clerk"
	var story = "Sir Pawn-a-lot's has a new clerk. Sorry folks, it's a slow news day. Swing by and say hello, I guess."
	$News.quick_setup(headline, story, set_score)
	$News.newspaper_arrive()
	
	yield($News,"newspaper_exited")
	emit_signal("rooster_crow")
	$ClockIn.clockin_arrive()
	emit_signal("clear_chat_log")
	
	yield($ClockIn, "clockin_exited")
	$AnimationPlayer.play("fade_to_clear")
	
	yield($AnimationPlayer,"animation_finished")
	emit_signal("begin_day")
	self.visible = false


func splash_overnight(set_head: String, set_story: String, set_score: Dictionary) -> void:
	self.visible = true
	$AnimationPlayer.play("fade_to_black")
	
	yield($AnimationPlayer,"animation_finished")
	emit_signal("transition_done")
	$News.quick_setup(set_head, set_story, set_score)
	$News.newspaper_arrive()
	
	yield($News,"newspaper_exited")
	emit_signal("rooster_crow")
	$ClockIn.clockin_arrive()
	emit_signal("clear_chat_log")
	
	yield($ClockIn, "clockin_exited")
	$AnimationPlayer.play("fade_to_clear")
	
	yield($AnimationPlayer,"animation_finished")
	emit_signal("begin_day")
	self.visible = false
	


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




#func _on_Button_pressed():
#	hide_stuff()
#	fade_out()
#	yield(self, "transition_done")
#	emit_signal("begin_day")
