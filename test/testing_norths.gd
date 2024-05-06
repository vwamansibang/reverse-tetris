extends Node2D

@onready var label = $Label
var total_str = ""
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	total_str = ""
	for block in get_tree().get_nodes_in_group("shape_group"):
		total_str += str(block.name) + ": " + str(block.check_if_under) + "\n"
		
	label.text = total_str
