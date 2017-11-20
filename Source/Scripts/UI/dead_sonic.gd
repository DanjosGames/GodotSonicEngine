extends Sprite

var game_over_yeah = null	# Used to display the "game over" sprite.

# Well, the player has had a death, so start the death animation playing.
func _ready():
	sound_player.play_sound ("Death")	# Play the death jingle.
	$"../Sonic".set ("visible", false)	# Make sure that...
	$"../Sonic/AnimatedSprite/Camera2D".current = false	# ...the player character is both not visible and that its camera is disabled during the animation.
	$Tween.connect ("tween_completed", self, "sonic_has_died")
	$Tween.interpolate_property (get_node ("."), "position", $"../Sonic".position, Vector2 ($"../Sonic".position.x, $"../Sonic".position.y+290), 1.50, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.set_repeat (false)
	$Tween.start ()
	return

# The animation is now over, so return the player to normal (after resetting various values), set them to a checkpoint position and resume control.
func sonic_has_died (done, key):
	$"../Sonic".lives -=1
	$"../Sonic".rings = 0
	$"../Sonic".position = $"../Sonic".checkpoint_pos
	$"../Sonic".dir_sign = Vector2 (0,0)
	$"../Sonic".move_dir = Vector2 (0,0)
	$"../Sonic".velocity = Vector2 (0,0)
	$"../Sonic".speed = Vector2 (0,0)
	if ($"../Sonic".lives >= 0):
		$"../Sonic/AnimatedSprite/Camera2D".current = true	# Not game over yet, so...
		$"../Sonic".set ("visible", true)			# ...re-enable the sprite and camera.
	else:
		# The game is now over, all lives have been lost.
		game_over_yeah = global_space.add_path_to_node ("res://Scenes/UI/game_over.tscn", "/root/World")
		game_over_yeah.get_node ("Camera2D").current = true
		game_over_yeah.position = $"../Sonic/AnimatedSprite/Camera2D".get_camera_position ()
	queue_free ()
	return
