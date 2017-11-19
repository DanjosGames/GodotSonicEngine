extends Sprite

var game_over_yeah = null

func _ready():
	sound_player.play_sound ("Death")
	get_node ("../Sonic").set ("visible", false)
	$"../Sonic/AnimatedSprite/Camera2D".current = false
	$Tween.connect ("tween_completed", self, "sonic_has_died")
	$Tween.interpolate_property (get_node ("."), "position", get_node ("../Sonic").position, Vector2 (get_node ("../Sonic").position.x, get_node ("../Sonic").position.y+290), 1.50, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.set_repeat (false)
	$Tween.start ()
	return

func sonic_has_died (done, key):
	get_node ("../Sonic").lives -=1
	get_node ("../Sonic").rings = 0
	get_node ("../Sonic").position = get_node ("../Sonic").checkpoint_pos
	$"../Sonic".dir_sign = Vector2 (0,0)
	$"../Sonic".move_dir = Vector2 (0,0)
	$"../Sonic".velocity = Vector2 (0,0)
	$"../Sonic".speed = Vector2 (0,0)
	if ($"../Sonic".lives >= 0):
		$"../Sonic/AnimatedSprite/Camera2D".current = true
		get_node ("../Sonic").set ("visible", true)
	else:
#		$"../Sonic/AnimatedSprite/Camera2D".force_update_scroll ()
		$"/root/World/AudioStreamPlayer".set_stream (preload ("res://Assets/Audio/Music/63_-_Game_Over.ogg"))
		$"/root/World/AudioStreamPlayer".play ()
		game_over_yeah = global_space.add_path_to_node ("res://Scenes/UI/game_over.tscn", "/root/World")
		game_over_yeah.get_node ("Camera2D").current = true
		game_over_yeah.position = Vector2($"../Sonic/AnimatedSprite/Camera2D".get_camera_position ())
	queue_free ()
	return
