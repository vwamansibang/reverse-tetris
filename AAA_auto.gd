extends Node

var follow_vector : Vector2
var temp_pause = false


var magnet_vector_data = Vector2.ZERO
var shape_vector_data = Vector2.ZERO
var shape_rotation_data = 0
var shape_type_data = null
var shape_texture_data = 0


func reset_vector_data():
	magnet_vector_data = Vector2.ZERO
	shape_vector_data = Vector2.ZERO
	shape_rotation_data = 0
	shape_type_data = null
	shape_texture_data = 0
