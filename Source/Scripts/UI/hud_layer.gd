extends CanvasLayer

onready var tween_node = $"Ring_Count/Tween"
var rings_zero = false	# To make sure the flashing animation for no rings is only called as needed.

func _ready():
	tween_node.set_tween_process_mode (Tween.TWEEN_PROCESS_IDLE)
	tween_node.interpolate_property (get_node ("Ring_Count"), "custom_colors/font_color", Color ("#ff0000"), Color ("#ffff00"), 1.75, tween_node.TRANS_LINEAR, tween_node.EASE_OUT_IN, 0.25)
	tween_node.set_repeat (true)
	pass

func _process (delta):
	# Make sure that the ring counter is flashing if the player has no rings, otherwise have it normal.
	if ($"../Sonic".rings == 0):
		if (!rings_zero):
			tween_node.reset ($"Ring_Count", "custom_colors/font_color")
			tween_node.resume ($"Ring_Count", "custom_colors/font_color")
			rings_zero = true
			print (tween_node.is_active ())
	if ($"../Sonic".rings > 0):
		rings_zero = false
		tween_node.stop ($"Ring_Count")
		$"Ring_Count".set ("custom_colors/font_color", Color ("#ffffff"))	# If it's not animated, you need to reset it to normal otherwise it'll stay wherever the tween had got to!
	return
