extends CanvasLayer

onready var tween_node = get_node ("Ring_Count/Tween")
var rings_zero = false	# To make sure the flashing animation for no rings is only called as needed.

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _physics_process (delta):
	# Make sure that the ring counter is flashing if the player has no rings, otherwise have it normal.
	if (str2var (get_node ("Ring_Count").get_text ()) == 0):
		if (!rings_zero):
			rings_zero = true
			tween_node.interpolate_property (get_node ("Ring_Count"), "custom_colors/font_color", Color ("#ff0000"), Color ("#ffff00"), 1.75, tween_node.TRANS_LINEAR, tween_node.EASE_OUT_IN, 0.25)
			tween_node.start ()
	else:
		rings_zero = false
		tween_node.stop_all ()
		get_node ("Ring_Count").set ("custom_colors/font_color", Color ("#ffffff"))
	return
