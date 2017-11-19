extends KinematicBody2D

var ring_taken = false

func _ready():
	return

# This doesn't really do much except remove the ring from the scene tree.
func ring_got ():
	if (!ring_taken):
		ring_taken = true
		visible = false
		print ("Ring got at ", position)
		queue_free ()
	return