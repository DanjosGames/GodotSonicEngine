extends KinematicBody2D

var ring_taken = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	return

func ring_got ():
	if (!ring_taken):
		ring_taken = true
		print ("Ring got at ", get_pos ())
		queue_free ()
	return
