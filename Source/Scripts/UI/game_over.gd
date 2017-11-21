extends Sprite

# The player has lost all their lives, so the game is over. Play the relevant music, show the relevant sprites, and then wait until
# any key is pressed and restart.

func _ready():
	$"/root/World/AudioStreamPlayer".stop ()
	$"/root/World/AudioStreamPlayer".stream = load ("res://Assets/Audio/Music/63_-_Game_Over.ogg")
	$"/root/World/AudioStreamPlayer".play ()
	get_tree ().set_pause (true)		# Pause the game in the background.
	return

# If any key is pressed, restart the game.
# TODO: Something a bit more refined than just restarting the whole program, but for now it'll do.
func _unhandled_key_input(event):
	if (event.pressed):
		get_tree ().set_pause (false)
		queue_free ()	# As this is queued, it'd be better put here than before reloading the main scene again.
		get_tree ().reload_current_scene()
	return
