### Eventually, this'll be something considerably more fancy and involved than a "press any key" prompt...

extends Control

func _ready ():
	print ("Main scene loaded...")
	music_player.play_music ("res://Assets/Audio/Music/Title_Theme.ogg")
	return

# If any key is pressed, start the game.
# TODO: Something a bit more refined than just restarting the whole program, but for now it'll do.
# TODO: Restarting the game from level_test.tscn doesn't restart from here (because this scene will have been unloaded).
func _unhandled_input (event):
	if (event.is_pressed ()):
		music_player.stop_music ()
		game_space.reset_values ()
		global_space.go_to_scene ("res://Scenes/Levels/All/level_test.tscn")
	return
