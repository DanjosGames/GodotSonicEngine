### Taken from the Godot demo suite, this implements a moving platform without too much trouble.

extends Node2D

# Member variables
export var motion = Vector2 ()	# The range of movement that the platform moves around with.
export var cycle = 1.0
var accum = 0.0

func _ready ():
	return

func _physics_process (delta):
	accum += delta * (1.0 / cycle) * PI * 2.0
	accum = fmod (accum, PI * 2.0)
	var d = sin (accum)
	var xf = Transform2D ()
	xf [2]= motion * d
	$platform.transform = xf
	return
