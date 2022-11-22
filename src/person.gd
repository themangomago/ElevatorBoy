extends Node2D


@export var walk_speed: float = 1.0
@export var waiting_time: float = 5.0

var desired_floor: int = 0

var state := Types.PersonState.Waiting
var time := waiting_time
var on_floor := true

# States
# PersonState {Waiting, Moving, Leaving}

# Called on creation from floor
func setup_floor(floor_level: int):
	
	# Generate Random Floor that is not ours
	desired_floor = floor_level 
	while(desired_floor == floor_level):
		desired_floor = Global.rng.randi() % Global.floor_levels
		
	state = Types.PersonState.Waiting
	
	$Target.set_text(str(desired_floor))
	$Target.show()
	
	on_floor = true

func setup_elevator(floor: int):
	desired_floor = floor

	$Target.set_text(str(desired_floor))
	$Target.show()
	
	on_floor = false

func moving():
	# animation
	$Target.hide()

func waiting():
	# animation
	$Target.show()

func flip(value):
	$Sprite2D.flip_h = value


func _process(delta):
	if on_floor and state == Types.PersonState.Waiting:
		time -= delta
		
		if time <= 0:
			_on_wait_timer_timeout()
	
	$Debug.set_text("s: " + str(state) + "\nt: " + str(time))

func _on_wait_timer_timeout():
	state = Types.PersonState.Leaving
	print("leaving")
