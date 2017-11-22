extends KinematicBody2D

const ACCEL_RATE = 0.046875
const DECEL_RATE = 0.5
const FRICTION = ACCEL_RATE
var TOP_SPEED = Vector2 (0, 0)	# The fastest the player can go. Actual values are set in <player_character_name>.gd.

export(int) var rings = 0 setget set_rings, get_rings		# Number of rings the player has.
export(int) var lives = 3 setget set_lives, get_lives		# Lives left.
export(int) var score = 0 setget set_score, get_score		# Score.
export(Vector2) var checkpoint_pos = Vector2(0,0)			# Co-ordinates of the last checkpoint reached.

func _ready ():
	print ("Generic player funcs initialised.")
	return

## SETTERS and GETTERS.
# get_ and set_ functions to allow the HUD counters to be updated. Nothing else needs to be done; these variables are automatically
# called via the setget definition for the variable (outside of the class; inside it, remember to use self!).

func get_lives ():
	if (has_node ("../hud_layer/Lives_Counter")):
		get_node ("../hud_layer/Lives_Counter").set_text (var2str (lives))
	return (lives)

func set_lives (value):
	if (value < lives):	# The player has died! Reset things to default values, set the player's position to the checkpoint etc.
		rings = 0
		global_space.add_path_to_node ("res://Scenes/UI/dead_player.tscn", "/root/World")
		position = checkpoint_pos
	elif (value > lives):	# The player has got an extra life!
		if (has_node ("$../AudioStreamPlayer")):
			$"../AudioStreamPlayer".stop ()
		if (has_node ("AudioStreamPlayer")):
			$AudioStreamPlayer.stream = load ("res://Assets/Audio/Music/One_Up.ogg")
			$AudioStreamPlayer.stop ()
			$AudioStreamPlayer.play ()
	lives = value
	if (has_node ("../hud_layer/Lives_Counter")):
		get_node ("../hud_layer/Lives_Counter").set_text (var2str (lives))
	return

func get_rings ():
	if (has_node ("../hud_layer/Ring_Count")):
		get_node ("../hud_layer/Ring_Count").set_text (var2str (rings))
	return (rings)

func set_rings (value):
	rings = value
	if (has_node ("../hud_layer/Ring_Count")):
		get_node ("../hud_layer/Ring_Count").set_text (var2str (rings))
	return

func set_score (value):
	score = value
	return

func get_score ():
	return (score)
