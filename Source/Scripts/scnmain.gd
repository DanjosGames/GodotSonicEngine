### Eventually, this'll be something considerably more fancy and involved than a "press any key" prompt...

extends Label

func _ready ():
	print ("Main scene loaded...")
	return

# If any key is pressed, start the game.
# TODO: Something a bit more refined than just restarting the whole program, but for now it'll do.
# TODO: Restarting the game from level_test.tscn doesn't restart from here (because this scene has been unloaded).
func _unhandled_key_input (event):
	if (event.pressed):
		game_space.reset_values ()
		global_space.go_to_scene ("res://Scenes/Levels/All/level_test.tscn")
	return
