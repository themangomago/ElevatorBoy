extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Menu/Label.set_text("FPS: " + str(Engine.get_frames_per_second()))
