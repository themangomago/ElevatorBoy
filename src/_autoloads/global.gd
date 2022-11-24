extends Node

const SCALE: int = 3

var floor_levels: int = 3

var money: int = 0
var rating: float = 3.0
var ratings: int = 1



var rng: RandomNumberGenerator

func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()


func add_rating(rating: float):
	ratings += 1
	self.rating = (self.rating * (ratings - 1) + rating) / ratings

func get_rating() -> float:
	return rating
