### GENERIC PLAYER SCRIPT.
# All the variables, functions etc. that are common to all playable characters go in here.
# Scripts should always check for nodes extending this script wherever possible.

extends RigidBody2D

# Set up sprite_anim and sprite_anim_node. The _node variable points to the animation node, of course.
# sprite_anim contains the animation currently playing.
onready var sprite_anim_node = $"AnimatedSprite"
onready var sprite_anim = sprite_anim_node.get_animation ()	# Make sure sprite_anim contains the default animation value.
onready var sprite_anim_frames = sprite_anim_node.get_sprite_frames ()

var siding_left = false
var jumping = false
var stopping_jump = false

var move_left = false
var move_right = false
var jump = false

var WALK_ACCEL = 800.0
var WALK_DEACCEL = 800.0
var WALK_MAX_VELOCITY = 200.0
var AIR_ACCEL = 200.0
var AIR_DEACCEL = 200.0
var JUMP_VELOCITY = 224
var STOP_JUMP_FORCE = 900.0

var MAX_FLOOR_AIRBORNE_TIME = 0.15

var airborne_time = 1e20

var floor_h_velocity = 0.0

export(Vector2) var checkpoint_pos = Vector2(0,0)			# Co-ordinates of the last checkpoint reached/starting position.

func _ready ():
	if ($"Jingle_Player"):
		$"Jingle_Player".connect ("finished", self, "jingle_finished")
	print ("Generic player functions initialised.")
	game_space.player_character = $"."	# Figure out who the current player character is...
	return

# change_anim
# func change_anim (new_anim)
# Changes the currently playing animation to one specified (by new_anim). Won't change the animation if it's already playing.
# Returns true if the animation has changed, false otherwise.
# TODO: Maybe make this function able to change direction animation plays in, etc.?
func change_anim (new_anim):
	if (new_anim != sprite_anim):	# This is a new animation...
		sprite_anim = new_anim		# ...so set sprite_anim to new_anim.
		sprite_anim_node.set_animation (sprite_anim)	# And make the sprite animation node play the new animation.
		return (true)
	return (false)

# If whatever Jingle_Player is playing was finished, resume the level's Music_Player.
func jingle_finished ():
	if ($"Jingle_Player"):	# Just in case!
		$"Jingle_Player".stop ()
	if ($"/root/Level/Music_Player"):	# Restart the level's music player, if necessary.
		if (!$"/root/Level/Music_Player".playing):
			$"/root/Level/Music_Player".play ()
	return

func _input (ev):
	# Get the controls
	if (visible == false || sprite_anim == "Die"):	# Player has died, so movement should not be possible!
		move_left = false	# Make sure...
		move_right = false	# ...the player cannot...
		jump = false		# ...be moving or jumping etc. once they're respawned.
		return
	move_left = Input.is_action_pressed ("move_left")
	move_right = Input.is_action_pressed ("move_right")
	jump = Input.is_action_pressed ("move_jump")

	if (Input.is_action_pressed ("DEBUG_kill")):	# FOR DEBUGGING ONLY. Kill the player!
		print ("DEBUG: kill player.")
		game_space.lives -=1

	if (Input.is_action_pressed ("DEBUG_extralife")):	# FOR DEBUGGING ONLY. Give an extra life.
		print ("DEBUG: extra life.")
		game_space.lives += 1

	if (Input.is_action_pressed ("DEBUG_gainrings")):	# FOR DEBUGGING ONLY. Gain 10 rings.
		print ("DEBUG: gain rings.")
		game_space.rings += 10

	if (Input.is_action_pressed ("DEBUG_loserings")):	# FOR DEBUGGING ONLY. Lose all rings.
		print ("DEBUG: lose rings.")
		game_space.rings = 0

	return

func _process (delta):
	return

func _physics_process (delta):
	return

func _integrate_forces (s):
	if (sprite_anim == "Die" || visible == false):	# Player's dead, make sure they don't move, reset to start/checkpoint position.
		s.set_linear_velocity (Vector2 (0,0))	# Bring any remaining movement speed to a halt.
		s.set_transform (Transform2D (0, checkpoint_pos))	# Move the player back to the start/the last checkpoint passed.
		return
	if (Input.is_action_pressed ("DEBUG_resetpos")):	# FOR DEBUGGING ONLY. Reset player to last checkpoint crossed, or start.
		print ("DEBUG: move player to last good checkpoint position.")
		move_left = false	# Make sure...
		move_right = false	# ...the player cannot...
		jump = false		# ...be moving or jumping etc. once they're respawned.
		s.set_linear_velocity (Vector2 (0,0))	# Bring any remaining movement speed to a halt.
		s.set_transform (Transform2D (0, checkpoint_pos))	# Move the player back to the start/the last checkpoint passed.
		change_anim ("Idle")
		return
	var lv = s.get_linear_velocity()
	var step = s.get_step()

	var new_siding_left = siding_left

	# Deapply prev floor velocity
	lv.x -= floor_h_velocity
	floor_h_velocity = 0.0

	# Find the floor (a contact with upwards facing collision normal)
	var found_floor = false
	var floor_index = -1

	for x in range (s.get_contact_count ()):
		var ci = s.get_contact_local_normal (x)
		if ci.dot (Vector2 (0, -1)) > 0.6:
			found_floor = true
			floor_index = x

	# A good idea when implementing characters of all kinds,
	# compensates for physics imprecision, as well as human reaction delay.
	if found_floor:
		airborne_time = 0.0
	else:
		airborne_time += step # Time it spent in the air

	var on_floor = airborne_time < MAX_FLOOR_AIRBORNE_TIME

	# Process jump
	if jumping:
		if lv.y > 0:
			# Set off the jumping flag if going down
			jumping = false
		elif not jump:
			stopping_jump = true

		if stopping_jump:
			lv.y += STOP_JUMP_FORCE * step

	if on_floor:
		# Process logic when character is on floor
		if move_left and not move_right:
			if lv.x > -WALK_MAX_VELOCITY:
				lv.x -= WALK_ACCEL * step
		elif move_right and not move_left:
			if lv.x < WALK_MAX_VELOCITY:
				lv.x += WALK_ACCEL * step
		else:
			var xv = abs(lv.x)
			xv -= WALK_DEACCEL * step
			if xv < 0:
				xv = 0
			lv.x = sign(lv.x) * xv

		# Check jump
		if not jumping and jump:
			lv.y = -JUMP_VELOCITY
			jumping = true
			stopping_jump = false
			sound_player.play_sound ("Jump")

		# Check siding
		if lv.x < 0 and move_left:
			new_siding_left = true
		elif lv.x > 0 and move_right:
			new_siding_left = false
		if jumping:
			print ("Jumping")
		elif abs(lv.x) < 0.1:
			change_anim ("Idle")
		else:
			change_anim ("Jog")
	else:
		# Process logic when the character is in the air
		if move_left and not move_right:
			if lv.x > -WALK_MAX_VELOCITY:
				lv.x -= AIR_ACCEL * step
		elif move_right and not move_left:
			if lv.x < WALK_MAX_VELOCITY:
				lv.x += AIR_ACCEL * step
		else:
			var xv = abs(lv.x)
			xv -= AIR_DEACCEL * step
			if xv < 0:
				xv = 0
			lv.x = sign(lv.x) * xv
		
#		if lv.y < 0:
#			change_anim ("Jumping")
#		else:
#			change_anim ("Falling")

	# Update siding
	if new_siding_left != siding_left:
		if new_siding_left:
			sprite_anim_node.set_flip_h (true)
		else:
			sprite_anim_node.set_flip_h (false)
		
		siding_left = new_siding_left

	# Apply floor velocity
	if found_floor:
		floor_h_velocity = s.get_contact_collider_velocity_at_position(floor_index).x
		lv.x += floor_h_velocity

	# Finally, apply gravity and set back the linear velocity
	lv += s.get_total_gravity() * step
	s.set_linear_velocity(lv)
	return
