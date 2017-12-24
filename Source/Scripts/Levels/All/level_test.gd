### Used by the test level, extends from the generic level script (as should all level scripts).

extends "res://Scripts/Levels/All/level_generic.gd"

func _ready ():
	$"Music_Player".stream = load ("res://Assets/Audio/Music/43-Final_Dreadnought_2.ogg")
	$"Music_Player".play ()
	print ("Level ready to go!")
	return

