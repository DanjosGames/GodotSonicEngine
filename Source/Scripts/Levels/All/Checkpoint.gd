extends Area2D

var taken = false

func _ready():
	get_node ("Sprite/AnimationPlayer").play ("spin_red")
	self.connect ("body_entered", self, "enter_checkpoint_body")
	return

func enter_checkpoint_body (body):
	if (!taken && body is preload ("res://Scripts/Player/player_generic.gd")):
		# The player has collided with the checkpoint, change the animation and set the checkpoint_pos vector to the checkpoint's position.
		taken = true
		$"AudioStreamPlayer2D".play ()
		print ("Checkpoint at ", position, " crossed.")
		get_node ("Sprite/AnimationPlayer").play_backwards ("spin_green")
		body.checkpoint_pos = position
	return
