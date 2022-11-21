extends Node2D


@export var walk_speed: float = 1.0


func _ready():
	pass

func flip(value):
	$Sprite2D.flip_h = value
