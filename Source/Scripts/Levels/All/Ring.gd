extends Area2D

var ring_taken = false

func _ready():
	self.connect ("body_entered", self, "got_ring")
	$AudioStreamPlayer2D.connect ("finished", self, "ring_got")
	return

func got_ring (body):
	if (!ring_taken && body is preload ("res://Scripts/Player/player_generic.gd")):	# Player has picked up the ring!
		ring_taken = true
		visible = false
		body.rings += 1
		$AudioStreamPlayer2D.play ()
	return

# This doesn't really do much except remove the ring from the scene tree.
func ring_got ():
	print ("Ring got at ", position)
	queue_free ()
	return
