extends Control

var in_focus_now = false
# Called when the node enters the scene tree for the first time.
func _ready():
#	$title_button.grab_focus()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func allow(value):
	if value and !in_focus_now:
		in_focus_now = true
		$title_button.grab_focus()
		
func deselect():
	for con in get_children():
		if con.has_focus():
			con.release_focus()
			in_focus_now = false
		
func _on_title_button_pressed():
	pass


func _on_title_button_2_pressed():
	pass


func _on_title_button_3_pressed():
	get_tree().quit()
