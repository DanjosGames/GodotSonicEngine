### Game over!
# The player has lost all their lives, so the game is over. Play the relevant music, show the relevant sprites, and then wait until
# any key is pressed and restart.

extends Sprite

func _ready():
	print ("Game over!")
	$"/root/Level/hud_layer".set ("layer", -99)
	if (has_node ("/root/Level/Music_Player")):
		$"/root/Level/Music_Player".stop ()	# Stop whatever other music is playing, and play the game over music instead.
		music_player.play_music ("res://Assets/Audio/Music/63_-_Game_Over.ogg")
	get_tree ().set_pause (true)		# Pause the game in the background.
	return

# If any key is pressed, restart the game.
# TODO: Something a bit more refined than just restarting the whole program, but for now it'll do.
func _unhandled_key_input(event):
	if (event.pressed):
		music_player.stop_music ()
		get_tree ().set_pause (false)
		game_space.reset_values ()	# Need to do this as singletons don't get reset by reload_current_scene.
		queue_free ()	# As this is queued, it'd be better put here than before reloading the main scene again.
		get_tree ().reload_current_scene()
	return

func _process (delta):
	game_space.player_character.set ("visible", false)
	$"/root/Level/hud_layer".set ("layer", -99)
	return
