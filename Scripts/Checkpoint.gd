extends Area2D

var taken = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	get_node ("Sprite/AnimationPlayer").play ("spin_red")
	self.connect ("body_enter", self, "enter_checkpoint_body")
	return

func enter_checkpoint_body (body):
	if (!taken && body extends preload ("res://Scripts/Player/Sonic.gd")):
		taken = true
		get_node ("Sprite/AnimationPlayer").play_backwards ("spin_green")
		body.checkpoint_pos = get_pos ()
		body.get_node ("SamplePlayer").play ("Checkpoint")
	return