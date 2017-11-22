extends Node

# Set up the world node (i.e., the node containing the level stuff) and sub-nodes as necessary here.
func _ready():
	if ($AudioStreamPlayer):	# Start the level music.
		$AudioStreamPlayer.stream = load ("res://Assets/Audio/Music/43-Final_Dreadnought_2.ogg")
		$AudioStreamPlayer.play ()
	return

### Might be a good idea to try and avoid _process functions here! Might not be avoidable, but keep it to a minimum.
