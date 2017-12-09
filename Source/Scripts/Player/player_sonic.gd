### PLAYABLE CHARACTER: Sonic.
# Sonic-only functionality goes in here. You should try avoiding referencing this script via collisions etc. unless there is no
# other option; use player_generic.gd instead.

extends "res://Scripts/Player/player_generic.gd"

func _ready():
	print ("Sonic entered the world at ", position)
	change_anim ("Idle")
	checkpoint_pos = position			# FOR DEBUGGING ONLY. Should normally be set by the level.
#	TOP_SPEED = Vector2 (360, 360)		# Sonic's maximum speed.
	game_space.update_hud ()			# This needs to be in the player character's _ready script.
	return
