extends Node2D


const person_scene = preload("res://src/person.tscn")

const DEFAULT_GRAVITY: float = 9
const MAX_SPEED: float = 3
const CRASH_SPEED: float = 4


var max_point: int = 96
var min_point: int = 0
var power: float = 2

var people: Array = []
var people_capacity: int = 2

var velocity: float = 0

var current_floor: Node = null

var state: Types.ElevatorState

func _get_current_force():
	# TODO: Calc load
	return power

# Add a person to the floor
func add_person(floor: int, pclass: Types.PersonClass):
	var person := person_scene.instantiate()
	person.position = $EntryPos.position
	$People.add_child(person)
	person.setup_elevator(floor)
	person.set_class(pclass)
	people.append(person)
	move_to_queue(people.size() - 1)


func has_space() -> bool:
	if people.size() < people_capacity:
		return true
	return false

# Move person to the exit spot of the elevator
func move_to_entry(spot: int):
	people[spot].moving(
		$EntryPos.position,
		Callable(self, "_entry_position_reached").bind(spot)
	)
	
# Remove person from the elevator or go back to the queue
func _entry_position_reached(spot: int):
	var person = people[spot]
	
	if current_floor and current_floor.floor == person.desired_floor:
		# Move to floor and remove
		current_floor.add_leaver(
			person.person_class, get_entry_global_position()
		)
		people[spot].queue_free()
		people.remove_at(spot)
	else:
		# Move to queue
		move_to_queue(spot)

# Move to free queue spot
func move_to_queue(spot: int):
	var spot_node = get_node("Places/p" + str(spot))
	people[spot].moving(spot_node.position, Callable(self, "_queue_position_reached").bind(spot))

# Queue position reached
func _queue_position_reached(spot: int):
	if people.size() > 0: #TODO
		people[spot].waiting()

func _process(delta):
	
	if Input.is_action_pressed("ui_up"):
		position.y -= 1
	elif Input.is_action_pressed("ui_down"):
		position.y += 1
		
	
	# TODO: cheat
#	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
#		velocity = max(velocity - power * delta, -MAX_SPEED)
#	else:
#		velocity += DEFAULT_GRAVITY * delta
	
	
#	position += Vector2(0, velocity )
#
#	if position.y > min_point:
#		position.y = min_point
#		if velocity > CRASH_SPEED:
#			print("crash")
#		velocity = 0
	
	var string = str(position) + "\n" + str(velocity)
	
	if current_floor:
		string += "\n floor: " + str(current_floor.floor)
	
	$Label.set_text(string)

	$Sprites/wheel.rotation +=  velocity * delta


func get_entry_global_position():
	return $EntryPos.global_position

func _on_area_2d_area_entered(area):
	current_floor = area.get_parent()
	current_floor.open_door()
	state = Types.ElevatorState.Offboarding
	
	var i = 0
	for person in people:
		if person.desired_floor == current_floor.floor:
			# Move first person who wants to exit on this floor
			move_to_entry(i)
			break
		i += 1


func _on_area_2d_area_exited(area):
	current_floor.close_door()
	current_floor = null
	state = Types.ElevatorState.NoFloor
