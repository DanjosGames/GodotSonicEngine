### PLAYABLE CHARACTER: Sonic.
# Sonic-only functionality goes in here. You should try avoiding referencing this script via collisions etc. unless there is no
# other option; use player_generic.gd instead.

extends "res://Scripts/Player/player_generic.gd"

func _ready ():
	if (OS.is_debug_build()):	# FOR DEBUGGING ONLY.
		print ("Sonic entered the world at ", position)
		checkpoint_pos = position			# FOR DEBUGGING ONLY. Should normally be set by the level.
	game_space.update_hud ()			# This needs to be in the player character's _ready script.
	change_anim ("Idle")
	return
