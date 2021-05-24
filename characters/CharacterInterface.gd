extends Node

### ### ## ## ## ### ###
### VARIABLES GALORE ###
### ### ## ## ## ### ###

enum { 
	DIALOG_GREETING,
	DIALOG_GOODBYE,
	DIALOG_AGREE_STRONG,
	DIALOG_AGREE,
	DIALOG_DECLINE,
	DIALOG_DELCINE_STRONG,
	DIALOG_GOSSIP,
	DIALOG_KEY_PHRASE,
}

const clerkfile = "res://characters/clerk.tres"
const clientfile = "res://characters/villagerInteractions02.tres"
const clientlist = "res://characters/client_list.tres"

var _client_list: Dictionary = {}
var _char_dictionary: Dictionary = {}
var _clerk_dictionary: Dictionary = {}
var _client_dictionary: Dictionary = {}

var current_interaction: Dictionary = {}
var current_client: Dictionary = {}

var rng := RandomNumberGenerator.new()
var _talk_chance: float = 0.30
var is_named_interaction:= false

### ### ### ### ## ### ### ###
### CORE PROCESS FUNCTIONS ###
### ### ### ### ## ### ### ###

func _ready():
	rng.randomize()
	
	var file = File.new()
	file.open(clerkfile, File.READ)
	_clerk_dictionary = parse_json(file.get_as_text())
	file.close()
	
	file.open(clientfile, File.READ)
	_client_dictionary = parse_json(file.get_as_text())
	file.close()
	
	file.open(clientlist, File.READ)
	_client_list = parse_json(file.get_as_text())
	file.close()
	
	# every stage, for now
	CharacterInterface._talk_chance = 1.0
	
	pass # Replace with function body.

func _process(_delta):
	pass # Replace with function body.



# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
#	CALCULATOR FUCNTIONS
#	These functions calculate things, but do not change values
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
func get_current_character() -> int:
	return current_client.name


func get_interaction_by_state(which: String) -> Array:
	var out: Array = []
	
	out = current_interaction[which]
	return out

func get_name() -> String:
	return current_client.name

func get_client_theme() -> String:
	return current_client.theme

func get_client_music() -> String:
	return current_client.bg_music

func get_client_portrait() -> String:
	return current_client.portrait

func get_item_choices() -> Dictionary:
	return {
		"itemA": current_interaction.config.itemA,
		"itemB": current_interaction.config.itemB,
		"itemC": current_interaction.config.itemC,
	}


func get_random_from_array(which: Array, duplicate: bool = false):
	var out
	var option_pick: int = 0
	
	if which.size() > 1:
		var option_max: int = which.size() - 1
		option_pick = rng.randi_range(0, option_max)
	
	out = which[option_pick].duplicate() if duplicate else which[option_pick]
	return out


# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
#	MUTATOR FUCNTIONS
#	These functions change values
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
func load_named_interaction(which: String) -> void:
	is_named_interaction = true
	var interaction_set: Dictionary = _client_dictionary["named_interactions"]
	var use: Dictionary = interaction_set[which].duplicate(true)
	
	load_client_dialog(use)
	load_client_details(use)


func load_random_interaction():
	is_named_interaction = false
	var interaction_set: Array = _client_dictionary["interactions"]
	var option_pick: int = 0
	
	if interaction_set.size() > 1:
		var option_max: int = interaction_set.size() - 1
		option_pick = rng.randi_range(0, option_max)
	
	var use: Dictionary = interaction_set[option_pick]
	
	load_client_dialog(use)
	load_client_details(use)

func load_client_dialog(which: Dictionary) -> void:
	#var tmp: Dictionary = _client_dictionary["interactions"][which]
	current_interaction = which.duplicate(true)
	
	var checklist := [
		"greeting",
		"ask",
		"fetch",
		"charge",
		"deliver",
		"goodbye",
		"eject_early",
		"eject_charge",
		"react_good",
		"react_neutral",
		"react_bad",
		"storm_out",
	]
	
	for i in checklist:
		if current_interaction[i].empty():
			var r = rng.randf()
			if r < _talk_chance:
				var stockphrases = _client_dictionary["stockPhrases"]
				var new_chat = get_random_from_array(stockphrases[i], true)
				
				current_interaction[i].push_back(new_chat)
				pass
	
	pass


func load_client_details(which: Dictionary)-> void:
	var cfg: Dictionary = which.config
	var client_key: String = ""
	
	# check if has specific character
	if cfg.has("char_req"):
		client_key = cfg.char_req
	else:
		# build list of pickable npcs, then select from them
		var pick_list := [] 
		for i in _client_list.keys():
			var can_rand: bool = _client_list[i].can_random
			var gender_any: bool = cfg.gender_req == "any"
			var gender:= "male" if _client_list[i].is_male else "female"
			
			if can_rand and (gender_any or cfg.gender_req == gender):
				pick_list.push_back(i)
		
		client_key = get_random_from_array(pick_list)
	
	current_client = _client_list[client_key].duplicate()

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



