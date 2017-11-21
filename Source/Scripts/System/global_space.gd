# This script is set up to use "/root/global_space" in the AutoLoad section of the project settings. This sets a global space for application-wide
# settings, flags, variables etc. which need to be easily passed around from scene/node to scene/node. It'd be a better idea to set up other
# singletons to use for actually gameplay-related stuff.

extends Node

# The following are used by go_to_scene.
onready var root = get_tree ().get_root ()
onready var current_scene = root.get_child (root.get_child_count () - 1)
onready var new_scene = null

func _ready ():
	print ("Global script loaded.")
	return

# add_child_to_node
# global_space.add_child_to_node (Scene_Instance, Node_to_Add_to)
# Adds an (instanced!) scene (Scene_Instance) as a child to the given node (Node_to_Add_to).
# This neither creates an instance nor frees it, so you need to do those before/after calling this function respectively.
# It also does no error checking, so pass wrong things and/or in the wrong order and things will break.
func add_child_to_node (Scene_Instance = null, Node_to_Add_to = "/root"):
	# Don't expect this to work properly (or at all) if you forget to create an *instance* of the scene to pass here!
	get_node (Node_to_Add_to).add_child (Scene_Instance)
	return

# add_path_to_node
# global_space.add_path_to_node (Scene_Path, Node_to_Add_to)
# Adds an instance of the scene specified by Scene_Path to the desired node (Node_to_Add_to).
# You should specify the path as absolute wherever possible.
# It doesn't do any error checking by and of itself, so do be careful!
# Returns the instance created.
func add_path_to_node (Scene_Path = "", Node_to_Add_to = "/root"):
	var s = ResourceLoader.load (Scene_Path)	# Load and...
	s = s.instance ()							# ...create an instance of the scene specified by the path.
	add_child_to_node (s, Node_to_Add_to)		# Then add it to the specified node.
	return (s)									# Return the instance created.

# go_to_scene
# global_space.go_to_scene (path)
# Goes to the relevant scene; the scene is a path, so "res://<filename>". You should specify the path as absolute wherever possible.
# Returns the resultant scene node as well.
func go_to_scene (path):
	var s = ResourceLoader.load (path)					# Load and...
	new_scene = s.instance ()						# ...create an instance of the scene to go to.
#	get_tree ().get_root ().add_child (new_scene)				# Add the scene to the current root of the scene tree.
	add_child_to_node (new_scene, get_tree ().get_root ().get_name ())	# Add the scene to the current root of the scene tree.
	get_tree ().set_current_scene (new_scene)				# Set the current scene being shown to the new scene...
	current_scene.queue_free ()						# ...delete the old scene from the tree...
	current_scene = new_scene						# ...and set the current_scene variable to be the new scene.
	return (current_scene)
