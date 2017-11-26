extends Sprite

var game_over_yeah = null	# Used to display the "game over" sprite.

# Well, the player has had a death, so start the death animation playing.
func _ready():
	sound_player.play_sound ("Death")		# Play the death jingle.
	$"../hud_layer".set ("layer", -99)		# Hide the HUD layer.
	position = game_space.player_character.position			# Set the position of this to where the player is.
	# Make sure that the player character is not visible and its camera is disabled during the animation.
	game_space.player_character.set ("visible", false)
	game_space.player_character.get_node ("Camera2D").current = false
	$Tween.connect ("tween_completed", self, "player_has_died")
	$Tween.interpolate_property ($".", "position", position, Vector2 (position.x, position.y+290), 1.50, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.set_repeat (false)
	$Tween.start ()
	return

# The animation is now over, so return the player to normal (after resetting various values), set them to a checkpoint position and
# resume control.
func player_has_died (done, key):
	if (game_space.lives >= 0):
		game_space.player_character.get_node ("Camera2D").current = true			# Not game over yet, so...
		game_space.player_character.set ("visible", true)			# ...re-enable the sprite and camera.
		$"../hud_layer".set ("layer", 32)			# ...reveal the HUD layer.
	else:
		# The game is now over; all lives have been lost. Show the game over stuff.
		game_over_yeah = global_space.add_path_to_node ("res://Scenes/UI/game_over.tscn", "/root/Level")
		game_over_yeah.get_node ("Camera2D").current = true
		game_over_yeah.position = game_space.player_character.get_node ("Camera2D").get_camera_position ()
	queue_free ()	# This instance is no longer required, so delete it.
	return
