### Kill zones. For things like bottomless pits or the like.
# Want to use them for other things? Size them as necessary in the object/scene you want - DON'T RESCALE!

extends Area2D

func _ready ():
	self.connect ("body_entered", self, "in_the_killzone")
	return

func in_the_killzone (body):
	if (body is preload ("res://Scripts/Player/player_generic.gd")):
		if (OS.is_debug_build()):
			print ("Player entered killzone at ", body.position, "!")	# FOR DEBUGGING ONLY.
		game_space.lives -=1
	return
