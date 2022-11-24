extends Node2D


var person_class: Types.PersonClass


const person_data: Array = [
	{"speed": 2, "wait_time": 10, "money": 5}, # Grandma
	{"speed": 5, "wait_time": 3, "money": 10}, # Businessman
	{"speed": 3, "wait_time": 6, "money": 7}, # Student
	{"speed": 4, "wait_time": 99, "money": 3}, # Employee
]

var desired_floor: int = 0

var state := Types.PersonState.Waiting
var time : float = 0.0
var on_floor := true


func _ready():
	assert(person_class != null)
	time = person_data[person_class].wait_time
	var start = Vector2(148, 80)
	var end = Vector2(114, 80)
	print(get_walking_time(start, end))



# Calculates how long the person needs to walk from point to point
func get_walking_time(start_pos: Vector2, end_pos: Vector2) -> float:
	# Ignore the y axis
	var temp_start = Vector2(start_pos.x, end_pos.y)
	var distance = temp_start.distance_to(end_pos)
	return distance / (person_data[person_class].speed * 10)

func get_score_and_money() -> Dictionary:
	if time > 1:
		return {"score": 5, "money": person_data[person_class].money}
	else:
		return {"score": 2, "money": person_data[person_class].money - 3}


# States
# PersonState {Waiting, Moving, Leaving}

func set_class(person: Types.PersonClass):
	# TODO: change sprite sheets
	self.person_class = person

# Called on creation from floor
func set_floor(floor_level: int):
	# Generate Random Floor that is not ours
	desired_floor = floor_level 
	while(desired_floor == floor_level):
		desired_floor = Global.rng.randi() % Global.floor_levels
		
	state = Types.PersonState.Waiting
	
	$Target.set_text(str(desired_floor))
	$Target.show()
	
	on_floor = true

func setup_floor_exit():
	pass

func setup_elevator(floor: int):
	desired_floor = floor

	$Target.set_text(str(desired_floor))
	$Target.show()
	
	on_floor = false

func moving(target_pos: Vector2, callback: Callable, use_global: bool = false):
	# animation
	$Target.hide()
	$AnimationPlayer.play("walk")

	var time = self.get_walking_time(self.position, target_pos)
	var parameter = "position"

	if use_global:
		time = self.get_walking_time(self.global_position, target_pos) / 2
		parameter = "global_position"

	var move_tween = get_tree().create_tween()
	move_tween.tween_property(
		self,
		parameter,
		target_pos,
		time
	)
	move_tween.tween_callback(callback)
	move_tween.play()
	$Debug2.set_text(str(callback))

	if self.position.x <= target_pos.x:
		_view_direction(Types.Direction.Right)
	else:
		_view_direction(Types.Direction.Left)

func waiting():
	# animation
	$Target.show()
	$AnimationPlayer.play("idle")

func _view_direction(direction: Types.Direction):
	if direction == Types.Direction.Left:
		$Sprite2D.flip_h = false
	else:
		$Sprite2D.flip_h = true

func _process(delta):
	if on_floor and state == Types.PersonState.Waiting:
		time -= delta
		
		if time <= 0:
			_on_wait_timer_timeout()
	
	$Debug.set_text("s: " + str(state) + "\nt: " + str(time) + "\nc:" + str(person_class) + "\nd:" + str(desired_floor) + "\n" + str(on_floor))

func _on_wait_timer_timeout():
	state = Types.PersonState.Leaving
	print("leaving")
