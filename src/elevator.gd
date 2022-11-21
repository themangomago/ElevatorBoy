extends Node2D


const person_scene = preload("res://src/person.tscn")

const DEFAULT_GRAVITY: float = 0.1
const MAX_SPEED: float = 0.15
const CRASH_SPEED: float = 0.10


var max_point: int = 96
var min_point: int = 0
var power: float = 0.1

var people: Array = []
var people_capacity: int = 2

var velocity: float = 0

var current_floor: Node = null


func _get_current_force():
	# TODO: Calc load
	return power

func add_person():
	var person := person_scene.instantiate()
	person.position = $EntryPos.position
	$People.add_child(person)
	people.append(person)
	move_to_queue(people.size() - 1)

func move_to_queue(spot: int):
	var spot_node = get_node("Places/p" + str(spot))
	var duration: float = (spot_node.position.x - people[spot].position.x)/(spot_node.position.x - $EntryPos.position.x)
	duration *= people[spot].walk_speed
	var move_tween = get_tree().create_tween()
	move_tween.tween_property(
		people[0],
		"position",
		spot_node.position,
		duration
	)
	move_tween.tween_callback(Callable(self, "_queue_position_reached"))
	move_tween.play()

func _queue_position_reached():
	people[0].flip(true)

func has_space() -> bool:
	if people.size() < people_capacity:
		return true
	return false



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

	$Sprites/wheel.rotation += 16 * velocity * delta


func get_entry():
	return $EntryPos.global_position

func _on_area_2d_area_entered(area):
	current_floor = area.get_parent()
	current_floor.open_door()


func _on_area_2d_area_exited(area):
	current_floor.close_door()
	current_floor = null
