### The generic level script.
# All scripts attached to levels should inherit from this script.

extends Node

onready var path_to_here = $".".get_path ()

# The default number of rings to collect to get an extra life. Set per-level for convenience.
export(int) onready var rings_to_collect = game_space.RINGS_FOR_EXTRA_LIFE

# Set up the world node (i.e., the node containing the level stuff) and sub-nodes as necessary here.
func _ready():
	return

### Might be a good idea to try and avoid _process functions here! Might not be avoidable, but keep it to a minimum.
