extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	pass

func _unhandled_key_input(event):
	if (event.pressed):
		get_tree ().reload_current_scene()
	return