### For use for game variables, constants etc. that will be accessed by other scenes/nodes/scripts throughout the game.
# Also does some (basic) game management.

extends Node

const RINGS_FOR_EXTRA_LIFE = 100	# Number of rings before an extra life. Don't use this directly...
const DEFAULT_RINGS = 0				# Default number of player rings.
const DEFAULT_LIVES = 3				# Ditto lives.
const DEFAULT_SCORE = 0				# Ditto score.

## These control the player character, and if anything needs to be done to/with it.
var player_character = null		# Who is the player character? Set up by the player_<character name>.gd script in its _ready.
var player_controlling_character = true	# Is the player controlling the character? Normally true. False for death/cutscenes/etc.
var reset_player_to_checkpoint = false	# Reset the player to the last checkpoint/start position if true.

onready var Game_Timer = Timer.new ()	# A universal timer.

## Set up variables for rings/collectibles, lives and score.
# These have setters and getters in order to allow gameplay-related events (extra lives, death etc.) to occur.
var rings = DEFAULT_RINGS setget set_rings, get_rings		# Number of rings the player has.
var lives = DEFAULT_LIVES setget set_lives, get_lives		# Lives left.
var score = DEFAULT_SCORE setget set_score, get_score		# Score.

# These variables control the timer. Probably not the most efficient way to do it, but it works, so...
var seconds = 0 setget set_seconds, get_seconds
var minutes = 0
var timer_paused = false

func _ready ():
	print ("Game-space functionality ready.")
	return

# Reset values to default. Note the lack of "self." here - otherwise it'd invoke the setters/getters!
# This needs to be done like this because singletons don't get reset on application/scene restart.
func reset_values ():
	rings = DEFAULT_RINGS
	lives = DEFAULT_LIVES
	score = DEFAULT_SCORE
	return

# Updates the HUD as required (for rings and lives and score, etc.). Called by the setters/getters for rings/score/time/lives.
func update_hud ():
	var prettied_time = ""	# Use this for the timer.
	if (!has_node ("/root/Level/hud_layer")):	# Can't update a HUD that is not there!
		return
	$"/root/Level/hud_layer/Lives_Counter".set_text (var2str (lives))
	$"/root/Level/hud_layer/Ring_Count".set_text (var2str (rings))
	# Put the timer together.
	prettied_time += var2str (minutes) + ":"
	if (seconds < 10):	# Add a relevant 0 (to keep the timer looking consistent).
		prettied_time += "0"
	prettied_time += var2str (seconds)
	$"/root/Level/hud_layer/Time_Count".text = prettied_time
#	print ("AAAA")	# FIXME: Add score stuff!
	return

## SETTERS and GETTERS.
# get_ and set_ functions to allow the HUD counters to be updated. Nothing else needs to be done; these variables are automatically
# called via the setget definition for the variable (outside of the class; inside it, remember to use self if needed!).
# These also allow for events such as extra lives and death of the player.

func get_lives ():
	update_hud ()
	return (lives)

func set_lives (value):
	if (value < lives):	# The player has died! Reset things to default values, set the player's position to the checkpoint etc.
		timer_paused = true
		player_character.set_linear_velocity (Vector2 (0,0))	# Stop the player moving.
		player_character.change_anim ("Die")
		player_character.set ("visible", false)
		global_space.add_path_to_node ("res://Scenes/UI/dead_player.tscn", "/root/Level")
		player_character.reset_player (false)
		timer_paused = false
	elif (value > lives):	# The player has got an extra life! Play the relevant music (if possible)!
		if (has_node ("/root/Level/Music_Player")):
			$"/root/Level/Music_Player".stop ()
		if (player_character.has_node ("Jingle_Player")):
			player_character.get_node ("Jingle_Player").stream = load ("res://Assets/Audio/Music/One_Up.ogg")
			player_character.get_node ("Jingle_Player").stop ()	# Collecting multiple lives can make things sound odd.
			player_character.get_node ("Jingle_Player").play ()
	lives = value
	update_hud ()
	return

func get_rings ():
	update_hud ()
	return (rings)

func set_rings (value):
	if (value < rings && !(lives < 0 || !player_controlling_character)):
		# Have lost rings through being hurt, as opposed to insta-kill etc.
		sound_player.play_sound ("LoseRings")				# Play the jingle.
	rings = value
	if (has_node ("/root/Level")):
		if (lives >= 0 && rings >= $"/root/Level".rings_to_collect):	# Got enough rings to get an extra life!
			$"/root/Level".rings_to_collect += game_space.RINGS_FOR_EXTRA_LIFE
			self.lives += 1
	update_hud ()
	return

func get_score ():
	update_hud ()
	return (score)

func set_score (value):
	score = value
	update_hud ()
	return

func get_seconds ():
	update_hud ()
	return (seconds)

func set_seconds (value):
	if (timer_paused):	# Timer is paused, so don't increment the timer.
		return
	seconds = value
	if (seconds > 59):	# A minute has passed, so update that!
		if (minutes >= 9):	# Ten minutes have passed, in fact, so kill the player.
			timer_paused = true
			self.lives -= 1
			return
		seconds = 0
		minutes += 1
	update_hud ()
	return
