### For use for game variables, constants etc. that will be accessed by every other scene/node/script throughout the game.
# Also does some (basic) game management.

extends Node

const RINGS_FOR_EXTRA_LIFE = 100	# Number of rings before an extra life. Don't use this directly...
const DEFAULT_RINGS = 0			# Default number of player rings.
const DEFAULT_LIVES = 3			# Ditto lives.
const DEFAULT_SCORE = 0			# Ditto score.

var player_character = null		# Who is the player character? Set up by the player_<character name>.gd script in its _ready.

# Set up variables for rings/collectibles, lives and score.
var rings = DEFAULT_RINGS setget set_rings, get_rings		# Number of rings the player has.
var lives = DEFAULT_LIVES setget set_lives, get_lives		# Lives left.
var score = DEFAULT_SCORE setget set_score, get_score		# Score.

func _ready ():
	print ("Game-space functionality ready.")
	return

# Reset values to default. Note the lack of "self." here - otherwise it'd invoke the setters/getters!
# This needs to be done like this because singletons don't get reset on application restart.
func reset_values ():
	rings = DEFAULT_RINGS
	lives = DEFAULT_LIVES
	score = DEFAULT_SCORE
	return

## SETTERS and GETTERS.
# get_ and set_ functions to allow the HUD counters to be updated. Nothing else needs to be done; these variables are automatically
# called via the setget definition for the variable (outside of the class; inside it, remember to use self!).

func get_lives ():
	if ($"/root/Level/hud_layer/Lives_Counter"):	# Make sure the HUD is up to date.
		$"/root/Level/hud_layer/Lives_Counter".set_text (var2str (lives))
	return (lives)

func set_lives (value):
	if (value < lives):	# The player has died! Reset things to default values, set the player's position to the checkpoint etc.
		rings = 0
		player_character.dir_sign = Vector2 (0,0)	# Stop...
		player_character.move_dir = Vector2 (0,0)	# ...the...
		player_character.velocity = Vector2 (0,0)	# ...player...
		player_character.speed = Vector2 (0,0)		# ...moving.
		player_character.change_anim ("Die")
		global_space.add_path_to_node ("res://Scenes/UI/dead_player.tscn", "/root/Level")
		player_character.change_anim ("Idle")		# Commenting this line out makes for a fun little bug!
		player_character.position = player_character.checkpoint_pos
	elif (value > lives):	# The player has got an extra life! Play the relevant music (if possible)!
		if ($"/root/Level/Music_Player"):
			$"/root/Level/Music_Player".stop ()
		if (player_character.has_node ("Jingle_Player")):
			player_character.get_node ("Jingle_Player").stream = load ("res://Assets/Audio/Music/One_Up.ogg")
			player_character.get_node ("Jingle_Player").stop ()
			player_character.get_node ("Jingle_Player").play ()
	lives = value
	if ($"/root/Level/hud_layer/Lives_Counter"):	# Make sure the HUD is up to date.
		$"/root/Level/hud_layer/Lives_Counter".set_text (var2str (lives))
	return

func get_rings ():
	if ($"/root/Level/hud_layer/Ring_Count"):	# Make sure the HUD is up to date.
		$"/root/Level/hud_layer/Ring_Count".set_text (var2str (rings))
	return (rings)

func set_rings (value):
	if (value < rings && !(lives < 0 || !player_character.get ("visible"))):
		# Have lost rings through being hurt, as opposed to insta-kill etc.
		sound_player.play_sound ("LoseRings")				# Play the jingle.
	rings = value
	if ($"/root/Level"):
		if (lives >= 0 && rings >= $"/root/Level".rings_to_collect):	# Got enough rings to get an extra life!
			$"/root/Level".rings_to_collect += game_space.RINGS_FOR_EXTRA_LIFE
			self.lives += 1
	if ($"/root/Level/hud_layer/Ring_Count"):				# Make sure the HUD is up to date.
		$"/root/Level/hud_layer/Ring_Count".set_text (var2str (rings))
	return

func set_score (value):
	score = value
	return

func get_score ():
	return (score)
