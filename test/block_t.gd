extends Node2D

@export var texture_type : int = 0
@export var shape_file = "res://test/block_t.tscn"
var check_if_under = false

func _ready():
	get_tree().call_group("shape_group", "autocheck")
	for part in self.get_children():
		if part == null:
			break
		part.easy_access()
	
func _process(delta):
	pass
	
func autocheck():
	for part in self.get_children():
		if part.confirm_north_ray():
			check_if_under = part.check_above()
			break
