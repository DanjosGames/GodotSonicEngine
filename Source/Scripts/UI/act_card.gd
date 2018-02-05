### Handles the act card being shown at the start of a level. Keeps it on screen for two seconds, then removes.

extends Sprite

func _ready():
	if (OS.is_debug_build ()):
		printerr ("Showing act card.")
	if (has_node ("/root/Level/hud_layer")):
		$"/root/Level/hud_layer".set ("layer", -99)		# Hide the HUD layer.
	position = game_space.player_character.position
	yield (get_tree ().create_timer (2.0), "timeout")
	game_space.reset_player_to_checkpoint = true
	game_space.seconds = 0
	game_space.minutes = 0
	queue_free ()
	return
