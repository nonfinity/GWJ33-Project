extends Control

### ### ## ## ## ### ###
### VARIABLES GALORE ###
### ### ## ## ## ### ###
signal newspaper_arrived
signal newspaper_exited


var headline: String 		setget set_headline, get_headline
var story: String 			setget set_story, get_story
var score: Dictionary 		setget set_score

### ### ### ### ## ### ### ###
### CORE PROCESS FUNCTIONS ###
### ### ### ### ## ### ### ###

func _ready():
	self.visible = false
	$ExitButton.visible = false


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
func quick_setup(set_head: String, set_story: String, set_score: Dictionary) -> void:
	set_headline(set_head)
	set_story(set_story)
	set_score(set_score)


func newspaper_arrive() -> void:
	$AnimationPlayer.play("spin_arrive")
	visible = true
	
	yield($AnimationPlayer, "animation_finished")
	$ExitButton.visible = true
	emit_signal("newspaper_arrived")


func newspaper_depart() -> void:
	$ExitButton.visible = false
	$AnimationPlayer.play("spin_depart")
	
	yield($AnimationPlayer, "animation_finished")
	visible = false
	emit_signal("newspaper_exited")

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
#	SETGET DEFINITIONS
#	Functions identified as setters or getters
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
func set_headline(val: String) -> void:
	$Headline.bbcode_text = str("[center]", val, "[/center]")


func get_headline() -> String:
	return $Headline.text


func set_story(val: String) -> void:
	$Story.text = val


func get_story() -> String:
	return $Story.text


func set_score(val: Dictionary) -> void:
	score = val.duplicate(true)
	
	var stars: float = 0.0
	var star_cnt: int = 0
	for i in range(1,5):
		stars += i * score.ranking[str(i,"star")]
		star_cnt += score.ranking[str(i,"star")]
	stars = 0.0 if star_cnt == 0 else stars / star_cnt
	
	var has_met: int = 0
	var has_foiled: int = 0
	
	if not score.clients.empty():
		for i in score.clients.values():
			has_met += 1 if i.has_met else 0
			has_foiled += 1 if i.has_foiled else 0
	
	$Score/Row1/cnt_cust.text = "%0d" % score.visits.total
	$Score/Row1/cnt_served.text = "%0d" % score.visits.served
	$Score/Row1/cnt_stars.text = "%0.1f" % stars
	$Score/Row2/cnt_met.text = "%0d" % has_met
	$Score/Row2/cnt_foiled.text = "%0d" % has_foiled
	
	self.update()



# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
#	ABSTRACT FUCNTIONS.
#	Child classes must define
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *

func abstract_example(): 
	assert(false, "Child classes must declare abstract_example()")



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




func _on_ExitButton_pressed():
	newspaper_depart()
