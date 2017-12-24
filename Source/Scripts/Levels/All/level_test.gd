### Used by the test level, extends from the generic level script (as should all level scripts).

extends "res://Scripts/Levels/All/level_generic.gd"

var seconds = 0
var minutes = 0

func _ready ():
	$"Music_Player".stream = load ("res://Assets/Audio/Music/43-Final_Dreadnought_2.ogg")
	$"Music_Player".play ()
	print ("Level ready to go!")
	if (has_node ("/root/Level/hud_layer")):
		$"/root/Level/hud_layer/Time_Count".text = "0:"+var2str (minutes)+":"+var2str (seconds)
	return

func _process (delta):
	if (minutes > 9 && seconds > 59):	# Level has been running for more than ten minutes.
		game_space.lives -=1			# Kill the player!
	return
