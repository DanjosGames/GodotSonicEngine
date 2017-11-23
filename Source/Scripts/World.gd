extends Node

onready var path_to_here = $".".get_path ()

# Set up the world node (i.e., the node containing the level stuff) and sub-nodes as necessary here.
func _ready():
	if ($"AudioStreamPlayer"):	# Start the level music.
		$"AudioStreamPlayer".stream = load ("res://Assets/Audio/Music/43-Final_Dreadnought_2.ogg")
		$"AudioStreamPlayer".play ()
	if (!$"hud_layer"):	# Make sure the HUD is usable from here if it isn't already.
		global_space.add_path_to_node ("res://Scenes/UI/hud_layer.tscn", path_to_here)
	return

### Might be a good idea to try and avoid _process functions here! Might not be avoidable, but keep it to a minimum.
