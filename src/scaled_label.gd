@tool
class_name ScaledLabel extends Label

func _ready():
	var scale_value: float = 1.0 / Global.SCALE
	scale = Vector2(scale_value, scale_value)
	print(scale)
