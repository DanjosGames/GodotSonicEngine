### PLAYABLE CHARACTER: Sonic.
# Sonic-only functionality goes in here. You should try avoiding referencing this script via collisions etc. unless there is no other option; use player_generic.gd instead.

extends "res://Scripts/Player/player_generic.gd"

func _ready():
	print ("Sonic entered the world at ", position)
	change_anim ("Idle")
	checkpoint_pos = position	# FOR DEBUGGING ONLY. Should normally be set by the level.
	TOP_SPEED = Vector2 (360, 360)	# Sonic's maximum speed.
	game_space.get_lives ()
	game_space.get_rings ()
	game_space.get_score ()
	return

func _input (ev):
	# Direction is -1 if Sonic is moving left/up, 1 if right/down, and 0 otherwise.
	# Can only move in one direction at a time (so pressing left while holding down right won't work)!

	if (game_space.lives < 0 || !get ("visible")):
		return

	if (Input.is_action_pressed ("move_left") && dir_sign.x != 1):
		dir_sign.x = -1
		sprite_anim_node.set_flip_h (true)
	elif (Input.is_action_pressed ("move_right") && dir_sign.x != -1):
		dir_sign.x = 1
		sprite_anim_node.set_flip_h (false)
	else:
		dir_sign.x = 0

	if (Input.is_action_pressed ("DEBUG_resetpos")):			# FOR DEBUGGING ONLY.
		print ("DEBUG: reset position to ", checkpoint_pos)
		speed = Vector2(0, 0)
		position = (checkpoint_pos)

	if (Input.is_action_pressed ("DEBUG_kill")):			# FOR DEBUGGING ONLY.
		print ("DEBUG: Kill")
		speed = Vector2(0, 0)
		game_space.lives -= 1

	if (Input.is_action_pressed ("DEBUG_extralife")):			# FOR DEBUGGING ONLY.
		print ("DEBUG: Extra life")
		game_space.lives += 1

	if (Input.is_action_pressed ("DEBUG_loserings")):			# FOR DEBUGGING ONLY.
		print ("DEBUG: Lose rings")
		game_space.rings = 0

	if (Input.is_action_pressed ("DEBUG_gainrings")):			# FOR DEBUGGING ONLY.
		print ("DEBUG: Gain rings")
		game_space.rings += 10

	return

func _process (delta):
	# move_dir is used to calculate and apply the direction of movement; dir_sign is for changing it.
	if (dir_sign != Vector2 (0, 0)):	# If the dir_sign isn't 0, make sure move_dir is consistent.
		move_dir = dir_sign

	if (dir_sign.x != 0):
		if (speed.x < TOP_SPEED.x):
			speed.x += ACCEL_RATE * delta	# Speed Sonic up until he is at top speed.
	else:
		if (speed.x > 0):
			speed.x -= FRICTION * delta		# Slow Sonic down according to the friction rating.
	# Change the animation, depending on what speed the player is moving at.
	if (sprite_anim != "Die"):
		if (speed.x > 0 && speed.x < 120):
			change_anim ("Walk")
		elif (speed.x >= 120):
			change_anim ("Jog")
		else:
			change_anim ("Idle")	# This is the default animation.

	return

func _physics_process (delta):
	## KEEP THESE AT THE BOTTOM OF THE FUNCTION, THESE ACTUALLY DO THE MOVEMENT AFTER EVERYTHING ELSE IS PROCESSED AND CALCULATED.
	velocity = (speed * move_dir)					# Ensure movement is in the correct direction.
#	print (velocity)								# FOR DEBUGGING ONLY.
	move_and_slide (velocity)					# And move Sonic appropriately.
	return

