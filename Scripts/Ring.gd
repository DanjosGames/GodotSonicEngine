extends KinematicBody2D

var ring_taken = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	return

# This doesn't really do much except remove the ring from the scene tree.
func ring_got ():
	if (!ring_taken):
		ring_taken = true
		print ("Ring got at ", get_pos ())
		queue_free ()
	return
