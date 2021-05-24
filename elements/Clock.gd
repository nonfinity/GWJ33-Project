extends Control

### ### ## ## ## ### ###
### VARIABLES GALORE ###
### ### ## ## ## ### ###
signal ticking_done

var _hours: int			setget set_hours
var _minutes: int		setget set_minutes

var _is_ticking: bool = false
var _tick_speed: float = 0.5 # hours per minute
var _tick_target: int

### ### ### ### ## ### ### ###
### CORE PROCESS FUNCTIONS ###
### ### ### ### ## ### ### ###

func _ready():
	set_time(_hours, _minutes)
	

func _process(delta):
	if _is_ticking:
		var add_min = round(delta * 60.0 * _tick_speed)
		add_time(add_min)
		
		if (_hours * 60 + _minutes) >= _tick_target:
			_is_ticking = false
			emit_signal("ticking_done")
	pass # Replace with function body.



# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
#	CALCULATOR FUCNTIONS
#	These functions calculate things, but do not change values
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
func hour_rad() -> float:
	var out := 0.0
	
	#out = _hours / 1.9
	out = (_hours * 60.0 + _minutes + 60) / (1.9 * 60.0 + 9.5)
	return out


func minute_rad() -> float:
	var out := 0.0
	
	out = _minutes / 9.5
	return out


func is_after(check_hours, check_minutes) -> bool:
	return get_total_minutes() > (check_hours * 60 + check_minutes)


func is_before(check_hours, check_minutes) -> bool:
	return get_total_minutes() < (check_hours * 60 + check_minutes)


func get_total_minutes() -> int:
	return (_hours * 60 + _minutes)

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
#	MUTATOR FUCNTIONS
#	These functions change values
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
func set_time(set_hours: int, set_minutes: int) -> void:
	# combine and re-modulo
	var total_minutes: int = set_hours * 60 + set_minutes
	_minutes = total_minutes % 60
	_hours = int(fmod((total_minutes - _minutes) / 60.0, 24.0))
	
	
	var h_rad = hour_rad()
	var m_rad = minute_rad()
	
	if is_instance_valid($Hours):
		$Hours.set_rotation(h_rad)
		
	if is_instance_valid($Minutes):
		$Minutes.set_rotation(m_rad)
	
	pass

func add_time(minute_count: int) -> void:
	set_time(_hours, _minutes + minute_count)

func tick_for(minute_count: int):
	_tick_target = get_total_minutes() + minute_count
	_is_ticking = true

func tick_til(til_hour: int, til_minute: int):
	_tick_target = (til_hour * 60 + til_minute)
	_is_ticking = true
	

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
#	SETGET DEFINITIONS
#	Functions identified as setters or getters
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
func set_hours(val: int) -> void:
	set_time(val, _minutes)


func set_minutes(val: int) -> void:
	set_time(_hours, val)

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


