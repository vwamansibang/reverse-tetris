extends Node2D

@export var texture_type : int = 0
@export var shape_file = "res://test/block_t.tscn"
var check_if_under = false

func _ready():
	get_tree().call_group("shape_group", "autocheck")
	
func _process(delta):
	for part in self.get_children():
		part.easy_access()
	
func autocheck():
	for part in self.get_children():
		if part.confirm_north_ray():
			check_if_under = part.check_above()
			break
