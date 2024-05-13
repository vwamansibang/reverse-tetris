extends TextureButton

@export_multiline var text = ""

@onready var label = $MarginContainer/Label

var default_pos = Vector2.ZERO
var prevent_repeat = false
func _ready():
	label.text = text
	default_pos = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.has_focus():
		tween_motion(72)
		if Input.is_action_just_pressed("pick"):
			pressed.emit()
	else:
		tween_motion(0)
		
func tween_motion(data_x):
#	if prevent_repeat:
#		return
#	prevent_repeat = true
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property(self, "position", default_pos - Vector2(data_x,0), 0.5)
	
#	await tween.finished
#	prevent_repeat = false
