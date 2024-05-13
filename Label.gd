extends Label

var prevent_repeat = false
var go_up = false
var default_pos = Vector2.ZERO
var speed = 1.2
func _ready():
	default_pos = position
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if prevent_repeat:
		return
	prevent_repeat = true
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CIRC)
	if !go_up:
		tween.tween_property(self, "position", default_pos+Vector2(0, 4), speed)
	elif go_up:
		tween.tween_property(self, "position", default_pos+Vector2(0, -4), speed)
	
	await tween.finished
	go_up = !go_up
	prevent_repeat = false
		
