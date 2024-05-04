extends CharacterBody2D

@export var texture_type : int = 0
@export var block_type : int = 0

var block_matrices = {
	1: [
		[0, 0, 0],
		[0, 0, 0],
		[0, 0, 0]
	],
	2: [
		[0, 0, 0],
		[0, 0, 0],
		[0, 0, 0]
	],
	3: [
		[0, 0, 0],
		[0, 0, 0],
		[0, 0, 0]
	],
	4: [
		[0, 0, 0],
		[0, 0, 0],
		[0, 0, 0]
	],
	5: [
		[0, 0, 0],
		[0, 0, 0],
		[0, 0, 0]
	],
	6: [
		[0, 0, 0],
		[0, 0, 0],
		[0, 0, 0]
	],
	7: [
		[0, 0, 0],
		[0, 0, 0],
		[0, 0, 0]
	],
	8: [
		[0, 0, 0],
		[0, 0, 0],
		[0, 0, 0]
	]
}
var matrix = []

# Called when the node enters the scene tree for the first time.
func _ready():
	matrix = block_matrices[block_type]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func place_blocks():
	for row in matrix:
		for col in row:
			# determine local pos
			# determine texture y
			# determine texture x + rotation
			
			#place block_shape on local pos
			#place texture on local pos
			pass
