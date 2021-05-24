extends Control

### ### ## ## ## ### ###
### VARIABLES GALORE ###
### ### ## ## ## ### ###

onready var state_dot = $Panel
onready var button_new = $Buttons/NewInteraction
onready var button_adv = $Buttons/AdvanceConvo
onready var button_out = $Buttons/DismissEject
onready var chatbox = $ChatBox

enum GSTATES {
	EMPTY,
	BEGIN,
	ASK,
	FETCH,
	CHARGE,
	RESPONSE,
	DELIVER,
	EJECT,
	ANGRY_DEPART
	GOODBYE,
	#END,
}

var live_state: int = GSTATES.BEGIN
var state_details = {
	GSTATES.EMPTY: {
		"can_eject": false,
		"can_advance": false,
		"can_gossip": false,
		"can_clockout": true,
		"file_key": "idle",
	},
	GSTATES.BEGIN: {
		"can_eject": true,
		"can_advance": true,
		"can_gossip": false,
		"can_clockout": false,
		"file_key": "greeting",
	},
	GSTATES.ASK: {
		"can_eject": true,
		"can_advance": true,
		"can_gossip": true,
		"can_clockout": false,
		"file_key": "ask",
	},
	GSTATES.FETCH: {
		"can_eject": false,
		"can_advance": false,
		"can_gossip": true,
		"can_clockout": false,
		"file_key": "fetch",
	},
	GSTATES.CHARGE: {
		"can_eject": false,
		"can_advance": true,
		"can_gossip": true,
		"can_clockout": false,
		"file_key": "charge",
	},
	GSTATES.RESPONSE: {
		"can_eject": true,
		"can_advance": true,
		"can_gossip": true,
		"can_clockout": false,
		"file_key": "react_",
	},
	GSTATES.DELIVER: {
		"can_eject": false,
		"can_advance": true,
		"can_gossip": true,
		"can_clockout": false,
		"file_key": "deliver",
	},
	GSTATES.EJECT: {
		"can_eject": false,
		"can_advance": true,
		"can_gossip": false,
		"can_clockout": false,
		"file_key": "goodbye",
	},
	GSTATES.ANGRY_DEPART: {
		"can_eject": false,
		"can_advance": true,
		"can_gossip": false,
		"can_clockout": false,
		"file_key": "storm_out",
	},
	GSTATES.GOODBYE: {
		"can_eject": false,
		"can_advance": true,
		"can_gossip": false,
		"can_clockout": false,
		"file_key": "goodbye",
	}
}

### ### ### ### ## ### ### ###
### CORE PROCESS FUNCTIONS ###
### ### ### ### ## ### ### ###

func _ready():
	CharacterInterface.set_character(CharacterInterface.CHAR_PALMER)
	#new_interaction()
	
	pass

func _process(_delta):
	pass # Replace with function body.



# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
#	CALCULATOR FUCNTIONS
#	These functions calculate things, but do not change values
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
func get_live_state_label() -> Label:
	var out: Label
	
	match live_state:
		GSTATES.ASK:
			out = $States/ask
		GSTATES.BEGIN:
			out = $States/begin
		GSTATES.CHARGE:
			out = $States/charge
		GSTATES.DELIVER:
			out = $States/deliver
		GSTATES.DISMISS:
			out = $States/dismiss
		GSTATES.END:
			out = $States/end
		GSTATES.FETCH:
			out = $States/fetch
	
	return out


func can_eject() -> bool:
	return state_details[live_state]["can_eject"]

func can_advance() -> bool:
	return state_details[live_state]["can_advance"]

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
#	MUTATOR FUCNTIONS
#	These functions change values
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
func new_interaction(_which: int = -1):
	chatbox.clear_chat_log()
	#CharacterInterface.load_client_dialog(4)
	CharacterInterface.load_random_client()
	set_state(GSTATES.BEGIN)
	
	## NEEDS MORE?
	pass

func set_state(which: int, file_key_override: String = "xxx") -> void:
	assert(GSTATES.values().has(which), "Tried to set state %0d but it doesn't exist!" % which)
	
	live_state = which
	move_state_indictator()
	button_out.disabled = true
	button_adv.disabled = true
	
	# call for dialog here
	if live_state != GSTATES.END:
		var file_key: String
		if file_key_override == "xxx":
			file_key = state_details[live_state]["file_key"]
		else:
			file_key = file_key_override
			
		var chat_set = CharacterInterface.get_interaction_by_state(file_key)
		
		for i in chat_set:
			var by_customer: bool = i.type == "client"
			chatbox.add_chat(i.dialog, by_customer)
			yield(get_tree().create_timer(1), "timeout")
	
	#chatbox.add_chat_by_type(CharacterInterface.DIALOG_GOODBYE)
	button_out.disabled = not can_eject()
	button_adv.disabled = not can_advance()
	
	pass

func advance_state() -> void:
	var new_state = (live_state + 1) % GSTATES.size()
	set_state(new_state)


func move_state_indictator() -> void:
	var which := get_live_state_label()
	
	#state_dot.rect_position.y = which.rect_position.y - 2.5
	state_dot.rect_global_position.y = which.rect_global_position.y - 2.5
	pass

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




func _on_NewInteraction_pressed():
	new_interaction()


func _on_DismissEject_pressed():
	var dismiss_type: String = "xxx"	#to match file key override default
	
	match live_state:
		GSTATES.CHARGE:
			dismiss_type = "eject_charge"
		_:
			dismiss_type = "eject_early"
	
	set_state(GSTATES.DISMISS, dismiss_type)


func _on_AdvanceConvo_pressed():
	advance_state()


func _on_SpinBox_value_changed(value: float):
	CharacterInterface._talk_chance = value / 100
