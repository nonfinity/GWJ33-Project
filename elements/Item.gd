extends Control

### ### ## ## ## ### ###
### VARIABLES GALORE ###
### ### ## ## ## ### ###

signal movement_done

export var pos_table: Vector2
export var pos_floor: Vector2

var pos_selected := Vector2(600.0, 440.0)
var pos_taken := Vector2(400.0, 370.0)
var pos_faraway := Vector2(550.0, 275.0)
var pos_outdoor := Vector2(200.0, 275.0)

signal button_pressed

var has_item:= false

### ### ### ### ## ### ### ###
### CORE PROCESS FUNCTIONS ###
### ### ### ### ## ### ### ###

func _ready():
	at_rest()

func _process(_delta):
	pass # Replace with function body.



# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
#	CALCULATOR FUCNTIONS
#	These functions calculate things, but do not change values
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
func get_image() -> Texture:
	return $Image.texture


# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
#	MUTATOR FUCNTIONS
#	These functions change values
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
func at_rest() -> void:
	visible = false
	rect_position = pos_floor
	rect_scale = Vector2.ONE
	modulate = Color(1.0, 1.0, 1.0, 1.0)
	rect_size = Vector2.ZERO


func arrive() -> void:
	if has_item:
		at_rest()
		
		$Tween.remove_all()
		$Tween.interpolate_property(self, "rect_position"
				, pos_floor, pos_table, 1.0, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
		
		visible = true
		$Tween.start()
		
		yield($Tween, "tween_all_completed")
		emit_signal("movement_done")


func abandon() -> void:
	$Tween.remove_all()
	$Tween.interpolate_property(self, "rect_position"
			, rect_position, pos_floor, 1.0, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(self, "modulate"
			, Color(1.0, 1.0, 1.0, 1.0), Color(1.0, 1.0, 1.0, 0.0), 1.0, Tween.TRANS_LINEAR)
	$Tween.start()
	
	yield($Tween, "tween_all_completed")
	emit_signal("movement_done")
	at_rest()


func leave_with() -> void:
	$Tween.remove_all()
	$Tween.interpolate_property(self, "rect_position"
			, pos_taken, pos_faraway, 0.7, Tween.TRANS_LINEAR)
	$Tween.interpolate_property(self, "rect_scale"
			, Vector2(1.0, 1.0), Vector2(0.5, 0.5), 0.7, Tween.TRANS_LINEAR)
	$Tween.start()
	
	yield($Tween, "tween_all_completed")
	$Tween.interpolate_property(self, "rect_position"
			, pos_faraway, pos_outdoor, 0.3, Tween.TRANS_LINEAR)
	$Tween.start()
	
	yield($Tween, "tween_all_completed")
	emit_signal("movement_done")
	at_rest()


func select() -> void:
	$Tween.remove_all()
	$Tween.interpolate_property(self, "rect_position"
			, pos_table, pos_selected, 1.0, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	
	visible = true
	$Tween.start()
	
	yield($Tween, "tween_all_completed")
	emit_signal("movement_done")


func take_item() -> void:
	$Tween.remove_all()
	$Tween.interpolate_property(self, "rect_position"
			, pos_selected, pos_taken, 1.0, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	
	visible = true
	$Tween.start()
	
	yield($Tween, "tween_all_completed")
	emit_signal("movement_done")


func set_image(filepath: String) -> void:
	has_item = (filepath.length() > 19)
	if has_item:
		var img = load(filepath)
		$Image.texture = img


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




func _on_Button_pressed():
	emit_signal("button_pressed")
