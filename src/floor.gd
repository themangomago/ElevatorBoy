extends Node2D


@export var floor: int = -1

const person_scene = preload("res://src/person.tscn")

var elevator_on_floor: bool = false
var person_at_enter_position: bool = false

var people_waiting: Array = []
var move_tween: Tween

var elevator: Node = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.set_text(str(floor))

func set_elevator(node: Node):
	elevator = node

func add_person():
	var person := person_scene.instantiate()
	var spot = get_node("Places/p" + str(people_waiting.size()))
	person.position = spot.position
	$People.add_child(person)
	people_waiting.append(person)


func _move_to_enter():
	var duration: float = (people_waiting[0].position.x - $Places/p0.position.x)/($Places/p0.position.x - $Enter.position.x)
	duration *= people_waiting[0].walk_speed
	if move_tween:
		move_tween.kill()
	move_tween = get_tree().create_tween()
	move_tween.tween_property(
		people_waiting[0],
		"position",
		$Enter.position,
		1
	)
	move_tween.tween_callback(Callable(self, "_enter_position_reached"))
	move_tween.play()
	people_waiting[0].flip(false)

func _move_to_queue():
	var duration: float = ($Places/p0.position.x - people_waiting[0].position.x)/($Places/p0.position.x - $Enter.position.x)
	duration *= people_waiting[0].walk_speed
	if move_tween:
		move_tween.kill()
	move_tween = get_tree().create_tween()
	move_tween.tween_property(
		people_waiting[0],
		"position",
		$Places/p0.position,
		duration
	)
	move_tween.tween_callback(Callable(self, "_original_position_exited"))
	move_tween.play()
	people_waiting[0].flip(true)
	person_at_enter_position = false


func open_door():
	elevator_on_floor = true
	$ElevatorShaft/Door/AnimationPlayer.play("open")
	
	if people_waiting.size() > 0:
		if elevator.has_space():
			_move_to_enter()


func close_door():
	elevator_on_floor = false
	$ElevatorShaft/Door/AnimationPlayer.play("close")

	if person_at_enter_position or (move_tween != null and move_tween.is_running()):
		_move_to_queue()

func _enter_position_reached():
	person_at_enter_position = true
	$EnterTimer.start()

func _original_position_exited():
	people_waiting[0].flip(false)


func _on_enter_timer_timeout():
	if elevator_on_floor:
		var tween := get_tree().create_tween()
		tween.tween_property(
			people_waiting[0],
			"global_position",
			elevator.get_entry(),
			people_waiting[0].walk_speed / 4
		)
		tween.play()
		tween.tween_callback(Callable(self, "_elevator_reached"))
	else:
		_move_to_queue()

func _elevator_reached():
	person_at_enter_position = false
	
	elevator.add_person()
	people_waiting[0].queue_free()
	people_waiting.pop_front()
	
	
