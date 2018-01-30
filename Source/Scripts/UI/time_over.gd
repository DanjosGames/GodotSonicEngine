### Deals with time over. Very similar to game over, really, just that this doesn't reset things for a new game.

extends Sprite

func _ready ():
	if (OS.is_debug_build()):	# FOR DEBUGGING ONLY.
		print ("TIME OVER")
	if (has_node ("/root/Level/Music_Player")):
		$"/root/Level/Music_Player".stop ()	# Stop whatever other music is playing, and play the game over music instead.
		music_player.play_music ("res://Assets/Audio/Music/63_-_Game_Over.ogg")
	get_tree ().set_pause (true)		# Pause the game.
	return

func _unhandled_key_input (event):
	if (event.pressed):
		music_player.stop_music ()
		$"/root/Level/Music_Player".play ()
		$"/root/Level/hud_layer".set ("layer", 32)
		get_tree ().set_pause (false)		# Unpause the game.
		queue_free ()	# Make sure this is removed when the time comes.
	return

func _process (delta):
	$"/root/Level/hud_layer".set ("layer", -99)
	return
