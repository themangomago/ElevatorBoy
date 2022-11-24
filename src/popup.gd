extends Node2D


var state := {
	"money": 0,
	"rating": 0,
	"run": 0
}

func setup(money: int, rating: int):
	$Content/Sprite2D.frame = 0
	state.money = money
	state.rating = rating
	
	$Content/Label.set_text("+" + str(money))
	$Content/AnimationPlayer.play("spawn")


func _on_animation_player_animation_finished(anim_name):
	if state.run == 0:
		Global.money += state.money
		state.run += 1
		
		$Content/Sprite2D.frame = 1
		$Content/Label.set_text("+" + str(state.rating))
		$Content/AnimationPlayer.play("spawn")
	else:
		Global.add_rating(state.rating)
		queue_free()
