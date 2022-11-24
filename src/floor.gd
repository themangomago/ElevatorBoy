extends Node2D


@export var floor: int = -1

const person_scene := preload("res://src/person.tscn")
const popup_scene := preload("res://src/popup.tscn")

var elevator_on_floor: bool = false
var person_at_enter_position: bool = false

var people_waiting: Array = []


var elevator: Node = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.set_text(str(floor))

func set_elevator(node: Node):
	elevator = node


# Add a person to the floor
func add_person(pclass: Types.PersonClass):
	var person := person_scene.instantiate()
	var spot = get_node("Places/p" + str(people_waiting.size()))
	person.position = spot.position
	person.set_class(pclass)
	person.set_floor(floor)
	$People.add_child(person)
	people_waiting.append(person)

# Adding a person who exited the elevator and leaving to the right now
func add_leaver(pclass: Types.PersonClass, global_pos: Vector2):
	print("add_leaver")
	# Instantiate a person
	var person := person_scene.instantiate()
	person.set_class(pclass)
	$People.add_child(person)
	person.global_position = global_pos

	# Move to the exit point (faster)
	person.moving(
		$Exit.position,
		Callable(self, "_leaver_position_reached").bind(person),
		false
	)


func _leaver_position_reached(person: Node):
	var data: Dictionary = person.get_score_and_money()
	var popup := popup_scene.instantiate()
	popup.position = $Exit.position - Vector2(0, 64)
	popup.setup(data.money, data.score)
	add_child(popup)

	# Move to exit
	person.moving(
		$OutOfScreen.position,
		Callable(person, "queue_free")
	)


# Move to position to enter elevator
func move_to_enter():
	people_waiting[0].moving($Enter.position, Callable(self, "_enter_position_reached"))

# Elevator enter position reached
func _enter_position_reached():
	person_at_enter_position = true
	people_waiting[0].waiting()
	
	if elevator_on_floor:
		people_waiting[0].moving(
			elevator.get_entry_global_position(),
			Callable(self, "_elevator_reached"),
			true
		)
	else:
		move_to_queue(0)

# Move back to queue
func move_to_queue(spot: int):
	people_waiting[spot].moving(
		get_node("Places/p" + str(spot)).position,
		Callable(self, "_queue_position_reached").bind(spot)
	)
	person_at_enter_position = false

# QUeue position reached
func _queue_position_reached(spot: int):
	if people_waiting.size() > 0: # TODO: should we reach this
		people_waiting[spot]
		people_waiting[spot].waiting()


func open_door():
	elevator_on_floor = true
	$ElevatorShaft/Door/AnimationPlayer.play("open")
	
	if people_waiting.size() > 0:
		if elevator.has_space():
			move_to_enter()


func close_door():
	elevator_on_floor = false
	$ElevatorShaft/Door/AnimationPlayer.play("close")

	if person_at_enter_position:
		move_to_queue(0)





func _elevator_reached():
	person_at_enter_position = false
	elevator.add_person(people_waiting[0].desired_floor, people_waiting[0].person_class)
	people_waiting[0].queue_free()
	people_waiting.pop_front()

