### For use for game variables, constants etc. that will be accessed by every other scene/node/script throughout the game.
# Also does some (basic) game management.

extends Node

const RINGS_FOR_EXTRA_LIFE = 100	# Number of rings before an extra life. Don't use this directly...

var player_character = null		# Who is the player character? Set up by the player_<character name>.gd script in its _ready.

func _ready ():
	print ("Game-space functionality ready.")
	return
