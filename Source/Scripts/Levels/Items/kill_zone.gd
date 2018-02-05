### Kill zones. For things like bottomless pits or the like.

extends Area2D

func _ready ():
	self.connect ("body_entered", self, "in_the_killzone")
	return

func in_the_killzone (body):
	if (body is preload ("res://Scripts/Player/player_generic.gd")):	# It's the player's character, so kill them!
		if (OS.is_debug_build()):	# FOR DEBUGGING ONLY.
			print ("Player entered killzone at ", body.position, "!")
		game_space.lives -= 1
	return
