extends Node2D

var follow = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if auto.follow_vector:
		position.x = auto.follow_vector.x
