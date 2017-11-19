# For playing general sound effects (mostly UI, but other stuff too as required).
# Sound effects MUST be specified in Sound_Library along the lines of "<name>": preload ("<filename>").
# (Or <name> = preload ("<filename>"), your choice.) (Or "<name>": load ("<filename>") etc etc.)
# Sound effects can be played using sound_player.play_sound ([<name>])

# Note it uses neither 2D or 3D effects, so should be kept primarily for UI or similar stuff.

extends AudioStreamPlayer

onready var Sound_Library = {
	# ADD SOUND EFFECTS HERE.
	No_Sound = preload ("res://Assets/Audio/Sound/No_Sound.ogg"),	# LEAVE ME HERE. KEEP ME AS THE FIRST ITEM IN THE LIST.
	Death = preload ("res://Assets/Audio/Sound/Death.ogg"),
	Ring = preload ("res://Assets/Audio/Sound/RingUp.wav"),
}

func _ready():
	print ("Sound player ready.")
	return

# play_sound
# play_sound (item)
# Looks for item in Sound_Library and if it's there, play it.
# Returns true if the item was found and the sound played, false otherwise.
func play_sound (item = "No_Sound"):
	if (item in Sound_Library):
		# The sound exists in the library, so play it out.
		stream = Sound_Library [item]
		play ()
		return (true)
	# Sound not found, so give an error.
	print ("ERROR: \"", item, "\" not found!")
	return (false)

# pause_sound
# pause_sound (yesno)
# Pauses the currently playing sound.
func pause_sound (yesno):
	pause_mode = yesno
	return
