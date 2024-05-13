extends Control

@onready var op1 = $TextureRect
@onready var op2 = $TextureRect2
@onready var op3 = $TextureRect3
var options = []

var default_x = 48
var default_pos = []
var get_focus = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	options = [op1, op2, op3]
	op1.set_focus_mode(Control.FOCUS_ALL)
	op2.set_focus_mode(Control.FOCUS_ALL)
	op3.set_focus_mode(Control.FOCUS_ALL)
	
	default_pos.append(op1.position)
	default_pos.append(op2.position)
	default_pos.append(op3.position)
	
	op1.grab_focus()
	print("op1 grabbed")
	print(op1.has_focus())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var cnt = 0
	for op in options:
#		if get_focus == cnt:
#			continue
		var tween=create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CIRC)
		if get_focus != cnt:
			tween.tween_property(op, "position", default_pos[cnt] + Vector2(default_x, 0), 1.5)
		cnt += 1
	
	if op1.has_focus():
		get_focus = 0
		print(op1.name)
	elif op2.has_focus():
		get_focus = 1
		print(op2.name)
	elif op3.has_focus():
		get_focus = 2
		print(op3.name)		
