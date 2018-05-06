### Handles the act card being shown at the start of a level. Keeps it on screen for two seconds, then removes.

extends Sprite

func _ready ():
	if (OS.is_debug_build ()):	# FOR DEBUGGING ONLY.
		printerr ("Showing act card.")
	if (has_node ("/root/Level/hud_layer")):
		$"/root/Level/hud_layer".layer = -99
	position = $"/root/Level/start_position".position
	yield (get_tree ().create_timer (2.0), "timeout")
	game_space.reset_player_to_checkpoint = true
	game_space.seconds = 0
	game_space.minutes = 0
	queue_free ()
	return
