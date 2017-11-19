extends KinematicBody2D

var dir_sign = Vector2 (0, 0)	# These determine which direction the character is moving in.
var move_dir = Vector2 (0, 0)	# These do the actual movement based on the direction.
var speed = Vector2 (0, 0)
var velocity = Vector2 (0, 0)
var brake_time = 0
var anim_speed = Vector2 (0, 0)

export(int) var rings = 0 setget set_rings, get_rings		# Number of rings the player has.
export(int) var lives = 3 setget set_lives, get_lives		# Lives left.
export(int) var score = 0 setget set_score, get_score		# Score.
export(Vector2) var checkpoint_pos	# Where was the last checkpoint? Make sure to set this to (0, 0) or the start position when on a new level etc.

# Set up sprite_anim and sprite_anim_node. The _node variable points to the animation node, of course.
# sprite_anim contains the animation currently playing.
onready var sprite_anim_node = get_node ("AnimatedSprite")
onready var sprite_anim = sprite_anim_node.get_animation ()	# Make sure sprite_anim contains the default animation value.
onready var sprite_anim_frames = sprite_anim_node.get_sprite_frames ()

const ACCEL_RATE = 0.046875
const DECEL_RATE = 0.5
const FRICTION = ACCEL_RATE
const TOP_SPEED = Vector2 (6, 6)	# The fastest Sonic can go.

func _ready():
	print ("Sonic entered the world at ", get_pos ())
	checkpoint_pos = get_pos ()	# FOR DEBUGGING ONLY.
	get_lives ()
	get_rings ()
	get_score ()
	set_fixed_process (true)
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
#		sprite_anim_node.set_animation_speed (sprite_anim, anim_speed)	#Changes the the speed by frames
#		sprite_anim_frames.set_animation_speed (sprite_anim, anim_speed)	#Changes the the speed by frames
		return (true)
	return (false)

func _fixed_process (delta):
	if (dir_sign != Vector2 (0, 0)):	# If the direction isn't 0, make sure it's consistent.
		move_dir = dir_sign		# move_dir is used to calculate and apply the direction of movement; dir_sign is for changing it.

	# Direction is -1 if Sonic is moving left/up, 1 if right/down, and 0 otherwise.
	# Can only move in one direction at a time (so pressing left while holding down right won't work)!
	if (Input.is_action_pressed ("move_left") && dir_sign.x != 1):
		dir_sign.x = -1
		sprite_anim_node.set_flip_h (true)
	elif (Input.is_action_pressed ("move_right") && dir_sign.x != -1):
		dir_sign.x = 1
		sprite_anim_node.set_flip_h (false)
	else:
		dir_sign.x = 0

	if (Input.is_action_pressed ("move_jump")):
		print ("AAAA")
		set_pos (checkpoint_pos)	# FOR DEBUGGING ONLY.

	if (dir_sign.x):
		if (speed.x < TOP_SPEED.x):
			speed.x += ACCEL_RATE	# Speed Sonic up until he is at top speed.
	else:
		if (speed.x > 0):
			speed.x -= FRICTION	# Slow Sonic down according to the friction rating.

	#AnimationChange
#	anim_speed = max (4 - (abs (speed)), 1)
	
	if (speed.x > 0 && speed.x < 3):
		change_anim ("Walk")
	elif (speed.x >= 3):
		change_anim ("Jog")
	else:
		change_anim ("Idle")	# This is the default animation.

	## KEEP THESE AT THE BOTTOM OF THE FUNCTION, THESE ACTUALLY DO THE MOVEMENT AFTER EVERYTHING ELSE IS PROCESSED AND CALCULATED.
	velocity = (speed * move_dir)	# Ensure movement is in the correct direction.
#	print (velocity)				# For debugging purposes.
	move (velocity)					# And move Sonic appropriately.

	if (is_colliding ()):				# Sonic is colliding with something!
		var this_is = get_collider ()		# Get what it is.
		if (this_is extends preload ("res://Scripts/Ring.gd")):	# It's a ring, so add to the ring count and then remove it.
			self.rings += 1	# Note that the "self." is needed in order to trigger the getter and setter functions!
			get_node ("SamplePlayer").play ("RingUp")
			this_is.ring_got ()

	return

## Setters and getters.
# get_ and set_ functions to allow the HUD counters to be updated. Nothing else needs to be done; these variables are automatically called via the
# setget definition for the variable (outside of the class; inside it, remember to use self!).

func get_lives ():
	if (has_node ("../hud_layer/Lives_Counter")):
		get_node ("../hud_layer/Lives_Counter").set_text (var2str (lives))
	return (lives)

func set_lives (value):
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
