extends Node2D





# Called when the node enters the scene tree for the first time.
func _ready():
	scale = Vector2i(Global.SCALE, Global.SCALE)
	
	$Floor.set_elevator($Elevator)
	$Floor2.set_elevator($Elevator)
	$Floor3.set_elevator($Elevator)
	$Floor4.set_elevator($Elevator)
	
	$Floor2.add_person(Types.PersonClass.Grandma)
	
	# $Floor2.add_person(Types.PersonClass.Student)
	# $Floor2.add_person(Types.PersonClass.Employee)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

