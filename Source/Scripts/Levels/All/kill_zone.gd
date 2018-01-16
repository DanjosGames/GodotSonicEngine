extends Area2D

func _ready ():
	self.connect ("body_entered", self, "in_the_killzone")
	return

func in_the_killzone (body):
	if (body is preload ("res://Scripts/Player/player_generic.gd")):
		game_space.lives -=1
	return