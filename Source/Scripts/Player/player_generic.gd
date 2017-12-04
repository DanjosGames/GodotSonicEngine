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
const GRAVITY_VEC = Vector2(0, 13440)
const FLOOR_NORMAL = Vector2(0, -1)
const SLOPE_SLIDE_STOP = 25.0
const MIN_ONAIR_TIME = 0.1

export(Vector2) var checkpoint_pos = Vector2(0,0)			# Co-ordinates of the last checkpoint reached/starting position.

var dir_sign = Vector2 (0, 0)	# These determine which direction the character is moving in.
var move_dir = Vector2 (0, 0)	# These do the actual movement based on the direction.
var speed = Vector2 (0, 0)		# Speed...
var velocity = Vector2 (0, 0)	# ...is controlled by these vectors.
var brake_time = 0
var anim_speed = Vector2 (0, 0)
var onair_time = 0
var on_floor = false

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
	if ($"/root/Level/Music_Player"):	# Restart the level's music player, if necessary.
		if (!$"/root/Level/Music_Player".playing):
			$"/root/Level/Music_Player".play ()
	return

func _input (ev):
	# Direction is -1 if the player is moving left/up, 1 if right/down, and 0 otherwise.
	# Can only move in one direction at a time (so pressing left while holding down right won't work)!

	if (game_space.lives < 0 || !get ("visible")):
		return
	if (Input.is_action_pressed ("move_left") && dir_sign.x != 1):
		dir_sign.x = -1
		sprite_anim_node.set_flip_h (true)
	elif (Input.is_action_pressed ("move_right") && dir_sign.x != -1):
		dir_sign.x = 1
		sprite_anim_node.set_flip_h (false)
	else:
		dir_sign.x = 0

	if (Input.is_action_pressed ("move_jump")):
		print ("Jump")
		sound_player.play_sound ("Jump")

	if (Input.is_action_pressed ("DEBUG_resetpos")):			# FOR DEBUGGING ONLY.
		print ("DEBUG: reset position to ", checkpoint_pos)
		speed = Vector2(0, 0)
		position = (checkpoint_pos)

	if (Input.is_action_pressed ("DEBUG_kill")):			# FOR DEBUGGING ONLY.
		print ("DEBUG: Kill")
		speed = Vector2(0, 0)
		game_space.lives -= 1

	if (Input.is_action_pressed ("DEBUG_extralife")):			# FOR DEBUGGING ONLY.
		print ("DEBUG: Extra life")
		game_space.lives += 1

	if (Input.is_action_pressed ("DEBUG_loserings")):			# FOR DEBUGGING ONLY.
		print ("DEBUG: Lose rings")
		game_space.rings = 0

	if (Input.is_action_pressed ("DEBUG_gainrings")):			# FOR DEBUGGING ONLY.
		print ("DEBUG: Gain rings")
		game_space.rings += 10

	return

func _process (delta):
	# move_dir is used to calculate and apply the direction of movement; dir_sign is for changing it.
	if (dir_sign != Vector2 (0, 0)):	# If the dir_sign isn't 0, make sure move_dir is consistent.
		move_dir = dir_sign

	if (dir_sign.x != 0):
		if (speed.x < TOP_SPEED.x):
			speed.x += ACCEL_RATE * delta	# Speed Sonic up until he is at top speed.
	else:
		if (speed.x > 0):
			speed.x -= FRICTION * delta		# Slow Sonic down according to the friction rating.

	if (speed.x < 0):	# Ensure movement does come to a stop (rounding errors and all that), as <0 counts as movement!
		speed.x = 0.0

	# Change the animation, depending on what speed the player is moving at.
	if (sprite_anim != "Die"):
		if (speed.x > 0 && speed.x < 120):
			change_anim ("Walk")
		elif (speed.x >= 120):
			change_anim ("Jog")
		else:
			change_anim ("Idle")	# This is the default animation.

	return

func _physics_process (delta):
	## KEEP THESE AT THE BOTTOM OF THE FUNCTION, THESE ACTUALLY DO THE MOVEMENT AFTER EVERYTHING ELSE IS PROCESSED AND CALCULATED.
	onair_time += delta
	velocity = (speed * move_dir)					# Ensure movement is in the correct direction.
	velocity += (GRAVITY_VEC * delta)
	print (velocity)								# FOR DEBUGGING ONLY.
	velocity = move_and_slide (velocity, FLOOR_NORMAL, SLOPE_SLIDE_STOP)
	if (is_on_floor()):
		onair_time = 0
	on_floor = onair_time < MIN_ONAIR_TIME
	return

