extends KinematicBody2D

var xdir = 0
var dir = 0
var speed = 0
var velocity = 0
var breaktime = 0

export(int) var Rings = 0	# Number of rings the player has.
export(int) var Lives = 3	# Lives left.
export(int) var Score = 0	# Score.

# Set up sprite_anim and sprite_anim_node. The _node variable points to the animation node, of course.
# sprite_anim contains the animation currently playing.
onready var sprite_anim_node = get_node ("AnimatedSprite")
var sprite_anim = ""

const ACCEL_RATE = 0.046875
const DECEL_RATE = 0.5
const FRICTION = ACCEL_RATE
const TOP_X_SPEED = 6

func _ready():
	set_fixed_process (true)
	sprite_anim = sprite_anim_node.get_animation()	# Make sure sprite_anim contains the default animation value on ready.
	print ("Sonic entered the world at ", get_pos ())
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

func _fixed_process (delta):
	if (xdir != 0):	# If the direction isn't 0, make sure it's consistent.
		dir = xdir	# dir is used to calculate the direction of movement, xdir is for changing it.

	# Direction is -1 if Sonic is moving left, 1 if right, and 0 otherwise.
	if (Input.is_action_pressed ("move_left")):
		xdir = -1
	elif (Input.is_action_pressed ("move_right")):
		xdir = 1
	else:
		xdir = 0

	if (xdir):
		if (speed < TOP_X_SPEED):
			speed += ACCEL_RATE	# Speed Sonic up until he is at top speed.
	else:
		if (speed > 0):
			speed -= FRICTION	# Slow Sonic down according to the friction rating.

	velocity = (speed * dir)		# Set the velocity for Sonic's movement (dir being used to signify direction).
	move (Vector2 (velocity, 0))	# And move Sonic appropriately.

	return

