### The checkpoint script.
# If the player dies, they are either reset to the start position, or the last checkpoint they passed by. This makes it happen.

extends Area2D

var taken = false

func _ready ():
	$"Sprite/AnimationPlayer".play ("spin_red")
	self.connect ("body_entered", self, "enter_checkpoint_body")
	return

func enter_checkpoint_body (body):
	if (!taken && body is preload ("res://Scripts/Player/player_generic.gd")):
		# The player has passed the checkpoint, change the animation and set checkpoint_pos vector to the checkpoint's position.
		taken = true	# A checkpoint can only be activated once.
		if (OS.is_debug_build()):	# FOR DEBUGGING ONLY.
			print ("Checkpoint at ", position, " crossed.")
		$"Sprite/AnimationPlayer".play_backwards ("spin_green")
		body.checkpoint_pos = position
		$"AudioStreamPlayer2D".play ()	# Play the checkpoint jingle.
	return
