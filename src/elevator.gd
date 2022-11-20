extends Node2D


const DEFAULT_GRAVITY: float = 0.1
const MAX_SPEED: float = 0.15
const CRASH_SPEED: float = 0.10


var max_point: int = 96
var min_point: int = 0
var power: float = 0.1


var velocity: float = 0

var current_floor: Node = null

func _get_current_force():
	# TODO: Calc load
	return power

func _process(delta):
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		velocity = max(velocity - power * delta, -MAX_SPEED)
		
	else:
		velocity += DEFAULT_GRAVITY * delta
	
	
	position += Vector2(0, velocity )
	
	if position.y > min_point:
		position.y = min_point
		if velocity > CRASH_SPEED:
			print("crash")
		velocity = 0
	
	$Label.set_text(str(position) + "\n" + str(velocity))


func _on_area_2d_area_entered(area):
	current_floor = area.get_parent()
	current_floor.open_door()


func _on_area_2d_area_exited(area):
	current_floor.close_door()
	current_floor = null
