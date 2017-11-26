### For use for game variables, constants etc. that will be accessed by every other scene/node/script throughout the game.

extends Node

const RINGS_FOR_EXTRA_LIFE = 100	# Number of rings before an extra life. Don't use this directly...

func _ready ():
	print ("Game-space functionality ready.")
	return
