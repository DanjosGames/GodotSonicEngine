extends "res://Scripts/Player/generic.gd"

var dir_sign = Vector2 (0, 0)	# These determine which direction the character is moving in.
var move_dir = Vector2 (0, 0)	# These do the actual movement based on the direction.
var speed = Vector2 (0, 0)
var velocity = Vector2 (0, 0)
var brake_time = 0
var anim_speed = Vector2 (0, 0)
var collision_checker = null

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
	print ("Sonic entered the world at ", position)
	checkpoint_pos = position	# FOR DEBUGGING ONLY.
	get_lives ()
	get_rings ()
	get_score ()
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

	if (Input.is_action_pressed ("move_jump")):
		speed = Vector2(0, 0)					# FOR DEBUGGING ONLY.
		position = (checkpoint_pos)	# FOR DEBUGGING ONLY.
	if (Input.is_action_pressed ("ui_select")):			# FOR DEBUGGING ONLY.
		global_space.add_path_to_node ("res://Scenes/UI/dead_sonic.tscn", "/root/World")
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
	collision_checker = get_slide_collision (0)

	if (collision_checker):				# Sonic is colliding with something!
		var this_is = collision_checker.get_collider ()		# Get what it is.
		print (collision_checker, " collided with ", this_is)		# FOR DEBUGGING ONLY.
		if (this_is is preload ("res://Scripts/Levels/All/Ring.gd")):	# It's a ring, so add to the ring count and then remove it.
			self.rings += 1	# Note that the "self." is needed in order to trigger the getter and setter functions!
			sound_player.play_sound ("Ring")
			this_is.ring_got ()
	return
