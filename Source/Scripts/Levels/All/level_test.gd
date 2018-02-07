### Used by the test level, extends from the generic level script (as should all level scripts).

extends "res://Scripts/Levels/All/level_generic.gd"

func _ready ():
	$"Music_Player".stream = load ("res://Assets/Audio/Music/Level_Test.ogg")
	$"Music_Player".play ()
	print ("Level ready to go!")
	# As this is called when the level is loaded, set the checkpoint position to the start position.
	return
