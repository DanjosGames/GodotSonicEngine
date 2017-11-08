extends KinematicBody2D

var xdir = 0
var dir = 0
var speed = 0
var velocity = 0
var breaktime = 0
var sprite_node
const ACC = 0.046875
const DEC = 0.5
const FRIC = ACC
const TOP = 6

func _ready():
	set_fixed_process(true)
	sprite_node = get_node("AnimatedSprite")

func _fixed_process(delta):
	if xdir:
		dir = xdir
	
	if Input.is_action_pressed("move_left"):
		xdir = -1
		sprite_node.set_flip_h(true)
	elif Input.is_action_pressed("move_right"):
		xdir = 1
		sprite_node.set_flip_h(false)
	else:
		xdir = 0
	
	if xdir:
		if speed < TOP:
			speed += ACC
	else:
		if speed > 0:
			speed -= FRIC
	
	velocity = speed * dir
	move(Vector2(velocity, 0))