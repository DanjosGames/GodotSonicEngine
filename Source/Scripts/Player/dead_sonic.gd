extends Sprite

func _ready():
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
	get_node ("../Sonic").set ("visible", true)
	$"../Sonic/AnimatedSprite/Camera2D".current = true
	return
