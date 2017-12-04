### Rings (aka collectibles).

extends Area2D

var ring_taken = false

func _ready():
	self.connect ("body_entered", self, "got_ring")
	$"AudioStreamPlayer2D".connect ("finished", self, "ring_got")
	$"Sprite".play ()
	return

func got_ring (body):
	if (!ring_taken && body is preload ("res://Scripts/Player/player_generic.gd")):
		ring_taken = true				# Player has picked up the ring! So make sure this ring is set as taken.
		visible = false					# And then as invisible, because of playing the sound.
		game_space.rings += 1			# Increase the player's rings count.
		$"AudioStreamPlayer2D".play ()	# And play the collected sound effect.
	return

# This doesn't really do much except remove the ring from the scene tree once the sound has finished playing.
func ring_got ():
	print ("Ring got at ", position)
	queue_free ()
	return
