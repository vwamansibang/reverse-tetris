extends Node2D

@export var texture_type : int = 0
@export var shape_file = load("res://test/block_t.tscn")
var check_if_under = false

func _ready():
	for part in self.get_children():
		part.easy_access()
	print("texture_checked")
