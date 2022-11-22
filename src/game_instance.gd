extends Node2D


# Z index:
# 0 - bg
# 1 - door
# 2 - persons
# 3 - foreground


# Called when the node enters the scene tree for the first time.
func _ready():
	scale = Vector2i(Global.SCALE, Global.SCALE)
	
	$Floor.set_elevator($Elevator)
	$Floor2.set_elevator($Elevator)
	$Floor3.set_elevator($Elevator)
	$Floor4.set_elevator($Elevator)
	
	$Floor3.add_person()
	
	$Floor2.add_person()
	$Floor2.add_person()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

