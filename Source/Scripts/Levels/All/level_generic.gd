### The generic level script.
# All scripts attached to levels should inherit from this script.

extends Node

onready var path_to_here = $".".get_path ()
var act_card_shown = false	# Has the act card been shown yet?

# The default number of rings to collect to get an extra life. Set per-level for convenience.
export(int) onready var rings_to_collect = game_space.RINGS_FOR_EXTRA_LIFE

# Set up the world node (i.e., the node containing the level stuff) and sub-nodes as necessary here.
func _ready ():
	game_space.player_controlling_character = false
	print ("Generic level functionality ready.")
	if (has_node ("/root/Level/hud_layer")):
		$"/root/Level/hud_layer".set ("layer", 32)
	if (has_node ("/root/Level/Timer_Level")):
		$"Timer_Level".connect ("timeout", self, "timer_add")
	return

# Controls the level timer. So long as the timer isn't paused, it'll add a second on to it.
func timer_add ():
	if (!game_space.timer_paused):	# If the timer has been paused, don't add to the game time, otherwise do.
		game_space.seconds += 1
	return
