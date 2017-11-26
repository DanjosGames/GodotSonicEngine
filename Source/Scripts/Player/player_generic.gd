### GENERIC PLAYER SCRIPT.
# All the variables, functions etc. that are common to all playable characters go in here.
# Scripts should always check for nodes extending this script wherever possible.

extends KinematicBody2D

# Set up sprite_anim and sprite_anim_node. The _node variable points to the animation node, of course.
# sprite_anim contains the animation currently playing.
onready var sprite_anim_node = $"AnimatedSprite"
onready var sprite_anim = sprite_anim_node.get_animation ()	# Make sure sprite_anim contains the default animation value.
onready var sprite_anim_frames = sprite_anim_node.get_sprite_frames ()

const ACCEL_RATE = 50
const DECEL_RATE = 30
const FRICTION = ACCEL_RATE
var TOP_SPEED = Vector2 (0, 0)	# The fastest the player can go. Actual values are set in player_<character_name>.gd.

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
	game_space.player_character = $"."	# Figure out who the current player character is...
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
	if ($"/root/Level/Music_Player"):	# Restart the level's music player.
		$"/root/Level/Music_Player".play ()
	return
