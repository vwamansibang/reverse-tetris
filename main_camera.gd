extends Camera2D


@onready var timer = $Timer
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func shake_up():
	timer.start()
	offset.y += 1
#	zoom = Vector2(1.005,1.005)
	await timer.timeout
	offset.y -= 1
#	zoom = Vector2.ONE

func freeze_frame(len):
	Engine.time_scale = 0
	await get_tree().create_timer(len, true, false, true).timeout
	Engine.time_scale = 1
