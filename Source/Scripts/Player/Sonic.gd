extends "res://Scripts/Player/generic.gd"

# Set up sprite_anim and sprite_anim_node. The _node variable points to the animation node, of course.
# sprite_anim contains the animation currently playing.
onready var sprite_anim_node = get_node ("AnimatedSprite")
onready var sprite_anim = sprite_anim_node.get_animation ()	# Make sure sprite_anim contains the default animation value.
onready var sprite_anim_frames = sprite_anim_node.get_sprite_frames ()

var dir_sign = Vector2 (0, 0)	# These determine which direction the character is moving in.
var move_dir = Vector2 (0, 0)	# These do the actual movement based on the direction.
var speed = Vector2 (0, 0)
var velocity = Vector2 (0, 0)
var brake_time = 0
var anim_speed = Vector2 (0, 0)

func _ready():
	print ("Sonic entered the world at ", position)
	checkpoint_pos = position	# FOR DEBUGGING ONLY. Should normally be set by the level.
	TOP_SPEED = Vector2 (6, 6)	# Sonic's maximum speed.
	get_lives ()
	get_rings ()
	get_score ()
	$"AudioStreamPlayer".connect ("finished", self, "jingle_finished")
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

func _input (ev):
	# Direction is -1 if Sonic is moving left/up, 1 if right/down, and 0 otherwise.
	# Can only move in one direction at a time (so pressing left while holding down right won't work)!

	if (lives < 0 || !get ("visible")):
		return

	if (Input.is_action_pressed ("move_left") && dir_sign.x != 1):
		dir_sign.x = -1
		sprite_anim_node.set_flip_h (true)
	elif (Input.is_action_pressed ("move_right") && dir_sign.x != -1):
		dir_sign.x = 1
		sprite_anim_node.set_flip_h (false)
	else:
		dir_sign.x = 0

	if (Input.is_action_pressed ("DEBUG_resetpos")):			# FOR DEBUGGING ONLY.
		print ("DEBUG: reset position to ", checkpoint_pos)
		speed = Vector2(0, 0)
		position = (checkpoint_pos)

	if (Input.is_action_pressed ("DEBUG_kill")):			# FOR DEBUGGING ONLY.
		print ("DEBUG: Kill")
		speed = Vector2(0, 0)
		self.lives -= 1

	if (Input.is_action_pressed ("DEBUG_extralife")):
		print ("DEBUG: Extra life")
		self.lives += 1
	return

func _process (delta):
	# move_dir is used to calculate and apply the direction of movement; dir_sign is for changing it.
	if (dir_sign != Vector2 (0, 0)):	# If the dir_sign isn't 0, make sure move_dir is consistent.
		move_dir = dir_sign

	if (dir_sign.x != 0):
		if (speed.x < TOP_SPEED.x):
			speed.x += ACCEL_RATE	# Speed Sonic up until he is at top speed.
	else:
		if (speed.x > 0):
			speed.x -= FRICTION	# Slow Sonic down according to the friction rating.

	# Change the animation, depending on what speed the player is moving at.
	if (speed.x > 0 && speed.x < 3):
		change_anim ("Walk")
	elif (speed.x >= 3):
		change_anim ("Jog")
	else:
		change_anim ("Idle")	# This is the default animation.
	return

func _physics_process (delta):
	## KEEP THESE AT THE BOTTOM OF THE FUNCTION, THESE ACTUALLY DO THE MOVEMENT AFTER EVERYTHING ELSE IS PROCESSED AND CALCULATED.
	velocity = (speed * move_dir)					# Ensure movement is in the correct direction.
#	print (velocity)								# FOR DEBUGGING ONLY.
	move_and_slide (velocity * 60)					# And move Sonic appropriately.
	return

# If whatever AudioStreamPlayer is playing was finished, resume the level's own AudioStreamPlayer.
func jingle_finished ():
	$"../AudioStreamPlayer".play ()
	return
