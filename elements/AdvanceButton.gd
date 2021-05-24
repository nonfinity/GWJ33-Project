extends Control

### ### ## ## ## ### ###
### VARIABLES GALORE ###
### ### ## ## ## ### ###
var door_position := Vector2(375.0, 170.0)
var desk_position := Vector2(510.0, 190.0)
var base_size := Vector2(90.0, 60.0)

signal button_pressed
signal movement_done
signal _bloop_done

#onready var _player = $AnimationPlayer

enum ANIM {
	ARRIVE,
	DEPART,
	BLOOP,
}

enum LOCATIONS {
	DESK,
	DOOR,
}

### ### ### ### ## ### ### ###
### CORE PROCESS FUNCTIONS ###
### ### ### ### ## ### ### ###

func _ready():
	at_rest()
	show()
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
func at_rest() -> void:
	visible = false
	rect_scale = Vector2.ONE
	modulate = Color(1.0, 1.0, 1.0, 1.0)
	rect_size = Vector2.ZERO

func move_to(where: int) -> void:
	visible = false
	match where:
		LOCATIONS.DESK:
			rect_position = desk_position 
		LOCATIONS.DOOR:
			rect_position = door_position


func set_showing(is_showing: bool) -> void:
	if is_showing:
		show()
	else:
		hide()


func hide():
	if visible:
#		_player.play("disappear")
#		yield(_player,"animation_finished")
		$Tween.remove_all()
		$Tween.interpolate_property(self, "rect_scale",
				Vector2.ONE, Vector2.ZERO, 0.3, Tween.TRANS_BACK,Tween.EASE_IN)
		$Tween.start()
		
		yield($Tween, "tween_all_completed")
	
	at_rest()
	emit_signal("movement_done")


func show():
	at_rest()
	if not visible:
		visible = true
		#_player.play("appear")
		#yield(_player, "animation_finished")
		$Tween.remove_all()
		$Tween.interpolate_property(self, "rect_scale",
				Vector2.ZERO, Vector2.ONE, 0.4, Tween.TRANS_BACK,Tween.EASE_OUT)
		$Tween.start()
		
		yield($Tween, "tween_all_completed")

#	bloop()
#	yield(self,"_bloop_done")
	emit_signal("movement_done")

func bloop() -> void:
	$Tween.remove_all()
	$Tween.interpolate_property(self, "rect_scale",
			Vector2(1.0, 1.0), Vector2(1.1, 1.1), 0.1, Tween.TRANS_BACK,Tween.EASE_OUT_IN)
	$Tween.start()
	
	yield($Tween, "tween_all_completed")
	$Tween.interpolate_property(self, "rect_scale",
			Vector2(1.1, 1.1), Vector2(1.0, 1.0), 0.1, Tween.TRANS_BACK,Tween.EASE_OUT_IN)
	
	yield($Tween, "tween_all_completed")
	emit_signal("_bloop_done")

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




func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("animation_finished",anim_name)


func _on_advance_pressed():
#	bloop()
#	yield(self, "_bloop_done")
	
	
	yield(hide(), "completed")
	emit_signal("button_pressed")
	
