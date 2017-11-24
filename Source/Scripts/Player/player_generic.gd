extends KinematicBody2D

# Set up sprite_anim and sprite_anim_node. The _node variable points to the animation node, of course.
# sprite_anim contains the animation currently playing.
onready var sprite_anim_node = get_node ("AnimatedSprite")
onready var sprite_anim = sprite_anim_node.get_animation ()	# Make sure sprite_anim contains the default animation value.
onready var sprite_anim_frames = sprite_anim_node.get_sprite_frames ()

const ACCEL_RATE = 0.046875
const DECEL_RATE = 0.5
const FRICTION = ACCEL_RATE
var TOP_SPEED = Vector2 (0, 0)	# The fastest the player can go. Actual values are set in <player_character_name>.gd.

export(int) var rings = 0 setget set_rings, get_rings		# Number of rings the player has.
export(int) var lives = 3 setget set_lives, get_lives		# Lives left.
export(int) var score = 0 setget set_score, get_score		# Score.
export(Vector2) var checkpoint_pos = Vector2(0,0)			# Co-ordinates of the last checkpoint reached/starting position.

var dir_sign = Vector2 (0, 0)	# These determine which direction the character is moving in.
var move_dir = Vector2 (0, 0)	# These do the actual movement based on the direction.
var speed = Vector2 (0, 0)		# Speed...
var velocity = Vector2 (0, 0)	# ...is controlled by these vectors.
var brake_time = 0
var anim_speed = Vector2 (0, 0)

func _ready ():
	if ($"Jingle_Player"):
		$"Jingle_Player".connect ("finished", self, "jingle_finished")
	print ("Generic player functions initialised.")
	return

# change_anim
# func change_anim (new_anim)
# Changes the currently playing animation to one specified (by new_anim). Won't change the animation if it's already playing.
# Returns true if the animation has changed, false otherwise.
# TODO: Maybe make this function able to change direction animation plays in, etc.?
func change_anim (new_anim):
	if (new_anim != sprite_anim):	# This is a new animation...
		sprite_anim = new_anim		# ...so set sprite_anim to new_anim.
		sprite_anim_node.set_animation (sprite_anim)	# And make the sprite animation node play the new animation.
		return (true)
	return (false)

# If whatever Jingle_Player is playing was finished, resume the level's Music_Player.
func jingle_finished ():
	if ($"Jingle_Player"):	# Just in case!
		$"Jingle_Player".stop ()
	if ($"/root/Level/Music_Player"):
		$"/root/Level/Music_Player".play ()
	return

## SETTERS and GETTERS.
# get_ and set_ functions to allow the HUD counters to be updated. Nothing else needs to be done; these variables are automatically
# called via the setget definition for the variable (outside of the class; inside it, remember to use self!).

func get_lives ():
	if ($"../hud_layer/Lives_Counter"):	# Make sure the HUD is up to date.
		$"../hud_layer/Lives_Counter".set_text (var2str (lives))
	return (lives)

func set_lives (value):
	if (value < lives):	# The player has died! Reset things to default values, set the player's position to the checkpoint etc.
		rings = 0
		dir_sign = Vector2 (0,0)	# Stop...
		move_dir = Vector2 (0,0)	# ...the...
		velocity = Vector2 (0,0)	# ...player...
		speed = Vector2 (0,0)		# ...moving.
		change_anim ("Die")
		global_space.add_path_to_node ("res://Scenes/UI/dead_player.tscn", "/root/Level")
		change_anim ("Idle")		# Commenting this line out makes for a fun little bug!
		position = checkpoint_pos
	elif (value > lives):	# The player has got an extra life! Play the relevant music (if possible)!
		if ($"/root/Level/Music_Player"):
			$"/root/Level/Music_Player".stop ()
		if ($"Jingle_Player"):
			$"Jingle_Player".stream = load ("res://Assets/Audio/Music/One_Up.ogg")
			$"Jingle_Player".stop ()
			$"Jingle_Player".play ()
	lives = value
	if ($"../hud_layer/Lives_Counter"):	# Make sure the HUD is up to date.
		$"../hud_layer/Lives_Counter".set_text (var2str (lives))
	return

func get_rings ():
	if ($"../hud_layer/Ring_Count"):	# Make sure the HUD is up to date.
		$"../hud_layer/Ring_Count".set_text (var2str (rings))
	return (rings)

func set_rings (value):
	if (value < rings && !(lives < 0 || !get ("visible"))):	# Have lost rings through being hurt, as opposed to insta-kill etc.
		sound_player.play_sound ("LoseRings")				# Play the jingle.
	rings = value
	if ($"../hud_layer/Ring_Count"):	# Make sure the HUD is up to date.
		$"../hud_layer/Ring_Count".set_text (var2str (rings))
	return

func set_score (value):
	score = value
	return

func get_score ():
	return (score)
