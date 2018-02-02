### Used by the test level, extends from the generic level script (as should all level scripts).

extends "res://Scripts/Levels/All/level_generic.gd"

func _ready ():
	$"Music_Player".stream = load ("res://Assets/Audio/Music/Level_Test.ogg")
	$"Music_Player".play ()
	print ("Level ready to go!")
	# As this is called when the level is loaded, set the checkpoint position to the start position.
	game_space.player_character.checkpoint_pos = $start_position.position
	game_space.player_controlling_character = false
	if (!act_card_shown):
		global_space.add_path_to_node ("res://Scenes/UI/act_card_TEST.tscn", get_path ())
		act_card_shown = true
#	game_space.reset_player_to_checkpoint = true	# Move the player character into position.
	return
