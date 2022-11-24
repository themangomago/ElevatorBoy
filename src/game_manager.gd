extends Control

# TODO:
# 23
# - Person exit on floor level
# - Elevator state (let people get out first)
# - Payment
# 24
# - People entering/leaving
# - Add multiple Days
# - Upgrades
# 25
# - Menu
# - Art
# 26
# - Art

# Time
# -> People wait for wait time. after that 3 seconds until they leave.
# -> Picking up in the last 3 seconds will result in decreased money
# -> Leaving people will rate you down


# Upgrades (2 offered randomly each end of day)
# -> Elevator power (speed)
# -> Elevator capacity (1, 2, 3 slots)
# -> Extend license (more floors)
# -> Boost rating (more money)


# Z index:
# 0 - bg
# 1 - door
# 2 - persons
# 3 - foreground


# Person Classes
# | Class       | Speed  | Patience | Money |
# |-------------|--------|----------|-------|
# | Grandma     | slow   | high     | low |
# | Businessman | fast   | low      | high |
# | Student     | medium | medium   | medium |
# | Employee    | medium | infinite | low |




# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$HUD/Label.set_text("FPS: " + str(Engine.get_frames_per_second()))
