extends KinematicBody2D

var xdir = 0
var dir = 0
var speed = 0
var velocity = 0
var breaktime = 0

export(int) var Rings = 0					# Number of rings the player has.
export(int) var Lives = 3					# Lives left.
export(int) var Score = 0					# Score.

onready var sprite_anim = get_node ("AnimatedSprite")

const ACC = 0.046875
const DEC = 0.5
const FRIC = ACC
const TOP = 6

func _ready():
	set_fixed_process (true)
	print ("Sonic entered the world at ", get_pos ())
	return

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
		if (speed < TOP):
			speed += ACC	# Speed Sonic up until he is at top speed.
	else:
		if (speed > 0):
			speed -= FRIC	# Slow Sonic down according to the friction rating.

	velocity = (speed * dir)		# Set the velocity for Sonic's movement (sign dir being used to signify direction).
	move (Vector2 (velocity, 0))	# And move Sonic appropriately.

	return

