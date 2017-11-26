extends Node

onready var path_to_here = $".".get_path ()

# The default number of rings to collect to get an extra life. Set per-level for convenience.
export(int) onready var rings_to_collect = game_space.RINGS_FOR_EXTRA_LIFE

# Set up the world node (i.e., the node containing the level stuff) and sub-nodes as necessary here.
func _ready():
	$"Music_Player".stream = load ("res://Assets/Audio/Music/43-Final_Dreadnought_2.ogg")
	$"Music_Player".play ()
	return

### Might be a good idea to try and avoid _process functions here! Might not be avoidable, but keep it to a minimum.
