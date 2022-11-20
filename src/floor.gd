extends Node2D


@export var floor: int = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.set_text(str(floor))

func open_door():
	$Elevator/Door/AnimationPlayer.play("open")

func close_door():
	$Elevator/Door/AnimationPlayer.play("close")
