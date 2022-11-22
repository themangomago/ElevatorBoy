extends Node

const SCALE: int = 3

var floor_levels: int = 3


var rng: RandomNumberGenerator

func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
