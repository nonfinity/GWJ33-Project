extends Control

#signal stage_transit_complete
signal move_ended
signal dialog_ended
signal BOD_done
signal EOD_done

signal next_state(which)

const item_folder = "res://assets/items/"

onready var score = $Managers/Score
onready var audio = $Managers/Music
onready var clock = $StoreView/Elements/Clock
onready var splash = $Splash
onready var client = $StoreView/Elements/character
onready var chatbox = $ChatBox
onready var daycount = $StoreView/Elements/DayCount
onready var client_anim = $StoreView/Elements/character/AnimationPlayer
onready var buttons := {
	"advance": $StoreView/Buttons/advance,
	"gossip": $StoreView/Buttons/gossip,
	"secret": $StoreView/Buttons/secret,
	"door": $StoreView/Buttons/door,
	"itemA": $StoreView/Elements/Item0,
	"itemB": $StoreView/Elements/Item1,
	"itemC": $StoreView/Elements/Item2,
	"charge0": $ItemDrawer/Charges/price0,
	"charge1": $ItemDrawer/Charges/price1,
	"charge2": $ItemDrawer/Charges/price2,
}
onready var choices := {
#	"item": {
#		"obj": $StoreView/Elements/pickedItem,
#		"anim": $StoreView/Elements/pickedItem/AnimationPlayer,
#		"which": "none",
#		"path": "",
#	},
	"charge": {
		"obj": $ItemDrawer/pickedCharge,
		"which": "none",
		"path": "",
	},
}

enum GSTATES {
	IDLE,
	BEGIN,
	ASK,
	FETCH,
	CHARGE,
	RESPONSE,
	DELIVER,
	EJECT_EARLY,
	EJECT_CHARGE,
	ANGRY_DEPART
	GOODBYE,
	AFTER_CLOSE,
	BEFORE_OPEN,
}
enum EOD_CHAR {
	PALMER,
	JACKSON,
	CHANDLER,
	BRODIE,
	TEST,
}

var state_details := {
	GSTATES.BEFORE_OPEN: {
		"can_eject": false,
		"can_advance": false,
		"can_gossip": false,
		"can_clockout": false,
		"show_items": false,
		"show_charges": false,
		"file_key": "idle",
		"advance_state": GSTATES.IDLE,
		"dismiss_state": null,
	},
	GSTATES.AFTER_CLOSE: {
		"can_eject": false,
		"can_advance": false,
		"can_gossip": false,
		"can_clockout": false,
		"show_items": false,
		"show_charges": false,
		"file_key": "idle",
		"advance_state": GSTATES.BEFORE_OPEN,
		"dismiss_state": null,
	},
	GSTATES.IDLE: {
		"can_eject": false,
		"can_advance": false,
		"can_gossip": false,
		"can_clockout": true,
		"show_items": false,
		"show_charges": false,
		"file_key": "idle",
		"advance_state": GSTATES.BEGIN,
		"dismiss_state": null,
	},
	GSTATES.BEGIN: {
		"can_eject": true,
		"can_advance": true,
		"can_gossip": false,
		"can_clockout": false,
		"show_items": false,
		"show_charges": false,
		"file_key": "greeting",
		"advance_state": GSTATES.ASK,
		"dismiss_state": GSTATES.EJECT_EARLY,
	},
	GSTATES.ASK: {
		"can_eject": true,
		"can_advance": true,
		"can_gossip": true,
		"can_clockout": false,
		"show_items": false,
		"show_charges": false,
		"file_key": "ask",
		"advance_state": GSTATES.FETCH,
		"dismiss_state": GSTATES.EJECT_EARLY,
	},
	GSTATES.FETCH: {
		"can_eject": false,
		"can_advance": false,
		"can_gossip": true,
		"can_clockout": false,
		"show_items": true,
		"show_charges": false,
		"file_key": "fetch",
		"advance_state": GSTATES.CHARGE,
		"dismiss_state": null,
	},
	GSTATES.CHARGE: {
		"can_eject": false,
		"can_advance": false,
		"can_gossip": true,
		"can_clockout": false,
		"show_items": false,
		"show_charges": true,
		"file_key": "charge",
		"advance_state": GSTATES.RESPONSE,
		"dismiss_state": null,
	},
	GSTATES.RESPONSE: {
		"can_eject": true,
		"can_advance": true,
		"can_gossip": true,
		"can_clockout": false,
		"show_items": false,
		"show_charges": false,
		"file_key": "react_",
		"advance_state": GSTATES.DELIVER,
		"dismiss_state": GSTATES.EJECT_CHARGE
	},
	GSTATES.DELIVER: {
		"can_eject": false,
		"can_advance": true,
		"can_gossip": true,
		"can_clockout": false,
		"show_items": false,
		"show_charges": false,
		"file_key": "deliver",
		"advance_state": GSTATES.GOODBYE,
		"dismiss_state": null,
	},
	GSTATES.EJECT_EARLY: {
		"can_eject": false,
		"can_advance": true,
		"can_gossip": false,
		"can_clockout": false,
		"show_items": false,
		"show_charges": false,
		"file_key": "eject_early",
		"advance_state": GSTATES.IDLE,
		"dismiss_state": null,
	},
	GSTATES.EJECT_CHARGE: {
		"can_eject": false,
		"can_advance": true,
		"can_gossip": false,
		"can_clockout": false,
		"show_items": false,
		"show_charges": false,
		"file_key": "eject_charge",
		"advance_state": GSTATES.IDLE,
		"dismiss_state": null,
	},
	GSTATES.ANGRY_DEPART: {
		"can_eject": false,
		"can_advance": true,
		"can_gossip": false,
		"can_clockout": false,
		"show_items": false,
		"show_charges": false,
		"file_key": "storm_out",
		"advance_state": GSTATES.IDLE,
		"dismiss_state": null,
	},
	GSTATES.GOODBYE: {
		"can_eject": false,
		"can_advance": true,
		"can_gossip": false,
		"can_clockout": false,
		"show_items": false,
		"show_charges": false,
		"file_key": "goodbye",
		"advance_state": GSTATES.IDLE,
		"dismiss_state": null,
	}
}
var idle_time := {
		"min": 15,
		"max": 180,
}
var headlines:= {
	1: { "headline": "Dukedom for Grabs", "story": "The Duke is dead without heir! King has announced a search for a new Duke. Challengers anticipated from far and wide"},
	2: { "headline": "New Hero In Town", 		"story": "Palmer, first-bon son of Larra arrived today to jockey for the dukedom. Calls his disinheritance irrelevant and vows success" },
	3: { "headline": "Brawler Arrives", 	"story": "Sir Jackson has announced his intent to compete for the dukedom. His famous fists give him an early lead among odds makers"},
	4: { "headline": "Hearthrob for Duke", "story": "Sir Brodie, called Of the Evenings, hearthrob of many as appeared in town. Says only he can mount the position of Duke"},
	5: { "headline": "Hail Sir Shephard", "story": "Born a peasant, Sir Chandler, formerly the Shephard, has decided to attempt to win the King's favor "},
	6: { "headline": "Geese Loose!", "story": "It happened"},
	7: { "headline": "Star Festival", "story": "It will happen in the next few months"},
	8: { "headline": "Lost Dog!", "story": "Where is it?"},
	9: { "headline": "New Witch", "story": "The swamp has a new witch. Swing by and say hello some time!"},
	10: { "headline": "King to Decide", "The King will announce his decision for the Duke in the next few days. All of the village is waiting with bated breath": "it happened"},
}


var credits = [
	{"theme": "thought", "speaker": "Will Leamon", "dialog": "Music, Portraits, and Items"},
	{"theme": "thought", "speaker": "Nomi Atoll", "dialog": "Programming, Storyboarding, Dialog"},
	{"theme": "thought", "speaker": "Diana Duplancic", "dialog": "3d art of shop interior"},
	#{"theme": "thought", "speaker": "Voices", "dialog": "Will Leamon & Crew"},
	{"theme": "thought", "speaker": "Special Thanks", "dialog": "ColdCalzone, Martin"},
]
var eod_char_keys := {
	EOD_CHAR.BRODIE: "brodie",
	EOD_CHAR.CHANDLER: "chandler",
	EOD_CHAR.JACKSON: "jackson",
	EOD_CHAR.PALMER: "palmer",
	#EOD_CHAR.TEST: "test_eod",
}
var secret_convos := {
	"brodie": [
		{ "type": "clerk", "dialog": "I know your secret", "score": {
			"clients": { "chandler": { "has_foiled": true}}
		} },
		{ "type": "client", "dialog": "Oh no!" },
		{ "type": "clerk", "dialog": "I am going to ruin you!" },
		{ "type": "clerk", "dialog": "There is nothing I can do to stop it!" },
	],
	"chandler": [
		{ "type": "clerk", "dialog": "I know your secret", "score": {
			"clients": { "chandler": { "has_foiled": true}}
		} },
		{ "type": "client", "dialog": "Oh no!" },
		{ "type": "clerk", "dialog": "I am going to ruin you!" },
		{ "type": "clerk", "dialog": "There is nothing I can do to stop it!" },
	],
	"jackson": [
		{ "type": "clerk", "dialog": "I know your secret", "score": {
			"clients": { "chandler": { "has_foiled": true}}
		} },
		{ "type": "client", "dialog": "Oh no!" },
		{ "type": "clerk", "dialog": "I am going to ruin you!" },
		{ "type": "clerk", "dialog": "There is nothing I can do to stop it!" },
	],
	"palmer": [
		{ "type": "clerk", "dialog": "I know your secret", "score": {
			"clients": { "chandler": { "has_foiled": true}}
		} },
		{ "type": "client", "dialog": "Oh no!" },
		{ "type": "clerk", "dialog": "I am going to ruin you!" },
		{ "type": "clerk", "dialog": "There is nothing I can do to stop it!" },
	],
	"test_eod": [
		{ "type": "clerk", "dialog": "I know your secret", "score": {
			"clients": { "chandler": { "has_foiled": true}}
		} },
		{ "type": "client", "dialog": "Oh no!" },
		{ "type": "clerk", "dialog": "I am going to ruin you!" },
		{ "type": "clerk", "dialog": "There is nothing I can do to stop it!" },
	],
}
var start_time := { "h": 9, "m": 0 }

var client_step_time: int = 5
var is_first_run: bool = true
var eod_interaction := ""
var eod_happened:= false
var picked_item: Control
var game_length_days:= 10
var day_count: int = 0

var live_state: int = GSTATES.BEFORE_OPEN
var rng := RandomNumberGenerator.new()


var portrait_path := "res://assets/portraits/"
var effects_path := "res://audio/effects/"
var music_path := "res://audio/music/"

func _ready():
	#CharacterInterface.set_character(CharacterInterface.CHAR_PALMER)
	rng.randomize()
	
	client_anim.play("char_peekaboo")
	client_anim.stop()
	client_anim.seek(0.0, true)
	
	choices.charge.obj.visible = false
	
	buttons.advance.at_rest()
	#set_state(GSTATES.BEFORE_OPEN)
	
	main_loop()

# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
#	CALCULATOR FUCNTIONS
#	These functions calculate things, but do not change values
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
func details() -> Dictionary:
	return state_details[live_state]

func can_eject() -> bool:
	return details()["can_eject"]

func can_advance() -> bool:
	return details()["can_advance"]

func can_gossip() -> bool:
	return details()["can_gossip"]

func can_clockout() -> bool:
	return details()["can_clockout"]


# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
#	MUTATOR FUCNTIONS
#	These functions change values
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
func main_loop() -> void:
	# expect logos, start ups and etc to be run elsewhere
	
	# daily loop
	while day_count <= game_length_days:
		day_count += 1
		
		# do day start stuff
		clock.set_time(start_time.h, start_time.m)
		
		# just using CharacterInterface for the random. Nothing else
		eod_interaction = CharacterInterface.get_random_from_array(eod_char_keys.values())
		
		BOD_steps()
		yield(self,"BOD_done")
		
		while clock.is_before(17, 0):
			# daily interactions
			
			# pass random time
			var wait_time:= rng.randi_range(idle_time.min, idle_time.max)
			clock.tick_for(wait_time)
			yield(clock, "ticking_done")
			
			# call in a rando & have an interaction
			yield(new_interaction(), "completed")
			
			
		
		# summon DBH
		#var i = {"theme": "thought", "speaker": "... Note to Self", "dialog": "Ahh... closing time"}
		
		chatbox.clear_chat_log()
		#chatbox.add_custom_chat(i.speaker, i.dialog, i.theme)
		chatbox.add_chat("Ahh... closing time", "thought")
		yield(chatbox, "chat_line_added")
		yield(get_tree().create_timer(1.5), "timeout")
		
		yield(new_interaction(eod_interaction), "completed")
		
		
		# EOD Stuff
		EOD_steps()
		yield(self,"EOD_done")
	
	pass
	
	# end game summary


func new_interaction(use_name: String = "") -> void:
	chatbox.clear_chat_log()
	if use_name == "":
		CharacterInterface.load_random_interaction()
	else:
		CharacterInterface.load_named_interaction(use_name)
		var bg_music = CharacterInterface.get_client_music()
		
		var filepath = str(music_path, bg_music)
		audio.named_client_arrives(filepath)
	
	var client_portrait = CharacterInterface.get_client_portrait()
	client.texture = load(str(portrait_path, client_portrait) )
	
	
	var next_state: int = GSTATES.BEGIN
	while next_state != GSTATES.IDLE:
		live_state = next_state
		var tmp  = yield(do_interaction_stage(next_state), "completed")
		
		if typeof(tmp) == TYPE_NIL:
			tmp = details().advance_state
		next_state = tmp
	
	if use_name != "":
		audio.named_client_departs()


# return next state
func do_interaction_stage(which: int) -> int:
	var out: int = GSTATES.IDLE

	yield(get_tree().create_timer(0.1), "timeout")
	prep_buttons(true)
	
	clock.tick_for(client_step_time)
	
	match which:
		GSTATES.BEGIN:
			client_anim.play("char_peekaboo")
			yield(client_anim, "animation_finished")
			
			dialog_from_key(details().file_key)
			yield(self,"dialog_ended")
			
			prep_buttons()
			out = yield(self, "next_state")
			
		GSTATES.ASK:
			move_to_desk()
			yield(self, "move_ended")
			
			dialog_from_key(details().file_key)
			yield(self,"dialog_ended")
			
			prep_buttons()
			out = yield(self, "next_state")
			
		GSTATES.FETCH:
			# do item selection
			prep_items()
			
			dialog_from_key(details().file_key)
			yield(self,"dialog_ended")
			
			prep_buttons()
			out = yield(self, "next_state")
			
		GSTATES.CHARGE:
			# do charge selection
			
			dialog_from_key(details().file_key)
			yield(self,"dialog_ended")
			
			prep_buttons()
			out = yield(self, "next_state")
			
		GSTATES.RESPONSE:
			# choose response
			var outcome: String = ""
			
			match rng.randi_range(1,10):
				1, 2:
					outcome = "good"
				3, 4, 5, 6:
					outcome = "neutral"
				7, 8:
					outcome = "bad"
				9, 10:
					outcome = "storm_out"
				_:
					assert(false, "RNG error!")
			
			#outcome = "good"
			if outcome == "storm_out":
				#set_state(GSTATES.ANGRY_DEPART)
				out = GSTATES.ANGRY_DEPART
				return
			else:
				dialog_from_key(str(details().file_key, outcome))
				yield(self,"dialog_ended")
				
				prep_buttons()
				out = yield(self, "next_state")
		
		GSTATES.DELIVER:
			picked_item.take_item()
			yield(picked_item, "movement_done")
			
			dialog_from_key(details().file_key)
			yield(self,"dialog_ended")
			
			prep_buttons()
			out = yield(self, "next_state")
		
		GSTATES.GOODBYE:
			dialog_from_key(details().file_key)
			yield(self,"dialog_ended")
			
			move_to_door(true)
			yield(self, "move_ended")
			
			#set_state(details().advance_state)
			out = details().advance_state
		
		GSTATES.EJECT_EARLY:
			dialog_from_key(details().file_key)
			yield(self,"dialog_ended")
			
			client_anim.play("char_exit")
			yield(client_anim, "animation_finished")
			
			buttons.advance.move_to(buttons.advance.LOCATIONS.DOOR)
			#set_state(details().advance_state)
			out = details().advance_state
		
		GSTATES.EJECT_CHARGE, GSTATES.ANGRY_DEPART:
			dialog_from_key(details().file_key)
			yield(self,"dialog_ended")
			
			move_to_door(false)
			yield(self, "move_ended")
			
			#set_state(details().advance_state)
			out = details().advance_state
		_:
			assert(false, "INVALID GAME STATE")
	
	return out

func dialog_from_key(which: String) -> void:		
	var chat_set := CharacterInterface.get_interaction_by_state(which)
	
	for i in chat_set:
		chatbox.add_chat(i.dialog, i.type)
		
		if i.has("audio"):
			if i.audio != "":
				var effect_path = str(effects_path, i.audio)
				audio.play_audio(effect_path, "effects")
		
		if i.has("score"):
			if typeof(i.score) == TYPE_DICTIONARY:
				score.add_score(i.score)
		
		#yield(get_tree().create_timer(0.6), "timeout")
		yield(chatbox, "chat_line_added")
	
	emit_signal("dialog_ended")


func move_to_desk() -> void:
	client_anim.play("char_enter")
	yield(client_anim, "animation_finished")
	#yield(get_tree().create_timer(1.0), "timeout")
	
	buttons.advance.move_to(buttons.advance.LOCATIONS.DESK)
	emit_signal("move_ended")	


func move_to_door(with_item: bool) -> void:
	client_anim.play("char_exit")
	
	if with_item:
		picked_item.leave_with()
	else:
		picked_item.abandon()
	
	yield(client_anim, "animation_finished")
	
	buttons.advance.move_to(buttons.advance.LOCATIONS.DOOR)
	emit_signal("move_ended")	


func prep_buttons(force_hide: bool = false):
	if force_hide:
		buttons.charge0.visible = false
		buttons.charge1.visible = false
		buttons.charge2.visible = false
		buttons.door.disabled = true
		
		buttons.advance.at_rest()
	else:
		buttons.charge0.visible = details().show_charges
		buttons.charge1.visible = details().show_charges
		buttons.charge2.visible = details().show_charges
		
		buttons.advance.set_showing( details().can_advance )
		#buttons.gossip.visible = details().can_gossip
		buttons.door.disabled = not details().can_eject
		
		if CharacterInterface.is_named_interaction and live_state == GSTATES.DELIVER:
			var s = score.has_secret(eod_interaction)
			var f = score.has_foiled(eod_interaction)
			
			if s and not f:
				buttons.secret.show()
	

func prep_items() -> void:
	var item_cfg = CharacterInterface.get_item_choices()
	
	buttons.itemA.set_image(str(item_folder, item_cfg.itemA))
	buttons.itemB.set_image(str(item_folder, item_cfg.itemB))
	buttons.itemC.set_image(str(item_folder, item_cfg.itemC))
	
	buttons.itemA.arrive()
	buttons.itemB.arrive()
	buttons.itemC.arrive()
	
	pass


func BOD_steps() -> void:
	# assume it's already faded in, either from game start or night time
	daycount.days = day_count
	if day_count == 1:
		splash.splash_first(score.score)
	
	# roll credits	
	chatbox.clear_chat_log()
	for i in credits:
		chatbox.add_custom_chat(i.speaker, i.dialog, i.theme)
		yield(chatbox, "chat_line_added")
	
	#show button and wait for press
	yield(splash, "begin_day")
	chatbox.clear_chat_log()
	emit_signal("BOD_done")
	


func EOD_steps() -> void:
	var news = headlines[day_count]
	
	audio.play_audio("res://audio/effects/owl_night.mp3", "effects")
	splash.splash_overnight(news.headline, news.story, score.score)
	#yield(splash,"transition_done")
	
	var i = {"theme": "thought", "speaker": "Good night", "dialog": "What a horrible night to have a curse"}
	
	chatbox.clear_chat_log()
	chatbox.add_custom_chat(i.speaker, i.dialog, i.theme)
	yield(chatbox, "chat_line_added")
	
	yield(get_tree().create_timer(1.5), "timeout")
	emit_signal("EOD_done")


# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
#	LISTENER FUNCTIONS
#	Functions connected to signals
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** *

func _on_door_pressed():
	#set_state(details().dismiss_state)
	emit_signal("next_state", details().dismiss_state)


func _on_advance_pressed():
	#set_state(details().advance_state)
	emit_signal("next_state", details().advance_state)


func _on_gossip_pressed():
	dialog_from_key("gossip")


func _on_item_pressed(which: int):
	match which:
		0:
			#       itemA chosen
			picked_item = buttons.itemA
			buttons.itemB.abandon()
			buttons.itemC.abandon()
		1:
			#       itemB chosen
			buttons.itemA.abandon()
			picked_item = buttons.itemB
			buttons.itemC.abandon()
		2:
			#       itemC chosen
			buttons.itemA.abandon()
			buttons.itemB.abandon()
			picked_item = buttons.itemC
		_:
			assert(false, "item press errror!!!")
	
	picked_item.select()
	
	yield(picked_item, "movement_done")
	#set_state(details().advance_state)
	emit_signal("next_state", details().advance_state)


func _on_charge_pressed(which: int):
	var _base_obj: Button
	var new_text: String
	
	
	match which:
		0:
			_base_obj = buttons.charge0
			new_text = "Low"
		1:
			_base_obj = buttons.charge1
			new_text = "Average"
		2:
			_base_obj = buttons.charge2
			new_text = "High"
		_:
			assert(false, "charge press errror!!!")
	
	choices.charge.obj.text = new_text
	choices.charge.obj.visible = true
	
	yield(get_tree().create_timer(1.0), "timeout")
	#set_state(details().advance_state)
	emit_signal("next_state", details().advance_state)


func _on_secret_pressed():
	var convo: Array = secret_convos[eod_interaction]
	
	# diable other buttons
	
	for i in convo:
		chatbox.add_chat(i.dialog, i.type)
		
		if i.has("audio"):
			if i.audio != "":
				var effect_path = str(effects_path, i.audio)
				audio.play_audio(effect_path, "effects")
		
		if i.has("score"):
			if typeof(i.score) == TYPE_DICTIONARY:
				score.add_score(i.score)
		
		#yield(get_tree().create_timer(0.6), "timeout")
		yield(chatbox, "chat_line_added")
	
	# re-enable other buttons


func _on_Splash_rooster_crow():
	audio.play_audio("res://audio/effects/rooster_morning.mp3", "effects")
