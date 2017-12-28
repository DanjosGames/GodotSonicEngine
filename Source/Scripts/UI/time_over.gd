extends Sprite

func _ready():
	if (has_node ("/root/Level/Music_Player")):
		$"/root/Level/Music_Player".stop ()	# Stop whatever other music is playing, and play the game over music instead.
		music_player.play_music ("res://Assets/Audio/Music/63_-_Game_Over.ogg")
	get_tree ().set_pause (true)		# Pause the game in the background.
	return

func _unhandled_key_input(event):
	if (event.pressed):
		music_player.stop_music ()
		$"/root/Level/Music_Player".play ()
		$"/root/Level/hud_layer".set ("layer", 32)
		queue_free ()	# As this is queued, it'd be better put here than before reloading the main scene again.
		game_space.player_character.set ("visible", true)
		get_tree ().set_pause (false)		# Pause the game in the background.
	return

func _process (delta):
	game_space.player_character.set ("visible", false)
	$"/root/Level/hud_layer".set ("layer", -99)
	return
