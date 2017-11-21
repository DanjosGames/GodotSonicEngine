extends CanvasLayer

var rings_zero = false	# To make sure the flashing animation for no rings is only called as needed.
var lives_zero = false	# To make sure the flashing animation for being on your last life is only called as needed.

func _ready():
	$"Tweens/Tween_Rings".set_tween_process_mode (Tween.TWEEN_PROCESS_IDLE)
	$"Tweens/Tween_Lives".set_tween_process_mode (Tween.TWEEN_PROCESS_IDLE)
	$"Tweens/Tween_Rings".interpolate_property ($"Ring_Count", "custom_colors/font_color", Color ("#ff0000"), Color ("#ffff00"), 1.75, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN, 0.25)
	$"Tweens/Tween_Lives".interpolate_property ($"Lives_Counter", "custom_colors/font_color", Color ("#ff0000"), Color ("#ffff00"), 1.75, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN, 0.25)
	$"Tweens/Tween_Rings".set_repeat (true)
	$"Tweens/Tween_Lives".set_repeat (true)
	pass

func _process (delta):
	# Make sure that the ring counter is flashing if the player has no rings, otherwise have it normal.
	if ($"../Sonic".rings == 0):
		if (!rings_zero):
			$"Tweens/Tween_Rings".reset ($"Ring_Count", "custom_colors/font_color")
			$"Tweens/Tween_Rings".resume ($"Ring_Count", "custom_colors/font_color")
			rings_zero = true
	else:
		rings_zero = false
		$"Tweens/Tween_Rings".stop ($"Ring_Count")
		$"Ring_Count".set ("custom_colors/font_color", Color ("#ffffff"))	# If it's not animated, you need to reset it to normal otherwise it'll stay wherever the tween had got to!
	# Make the lives count flash if it is zero.
	if ($"../Sonic".lives < 1):
		if (!lives_zero):
			$"Tweens/Tween_Lives".reset ($"Lives_Counter", "custom_colors/font_color")
			$"Tweens/Tween_Lives".resume ($"Lives_Counter", "custom_colors/font_color")
			lives_zero = true
	else:
		lives_zero = false
		$"Tweens/Tween_Lives".stop ($"Lives_Counter")
		$"Lives_Counter".set ("custom_colors/font_color", Color ("#ffffff"))	# If it's not animated, you need to reset it to normal otherwise it'll stay wherever the tween had got to!
	return
