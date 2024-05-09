extends Node2D

@export var sign1 : int = 0
@export var sign2 : int = 0
@export var sign3 : int = 0

var clear1 = false
var clear2 = false
var clear3 = false
var error = false
var show_error = false
var time_starting = false

@onready var sign_img1 = $Sprite2D
@onready var sign_img2 = $Sprite2D2
@onready var sign_img3 = $Sprite2D3
@onready var error_img = $error_img
@onready var timer = $Timer
# Called when the node enters the scene tree for the first time.
func _ready():
	sign_img1.hide()
	sign_img2.hide()
	sign_img3.hide()
	error_img.hide()
	
	set_signs()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	print("CLears: ", clear1, ", ", clear2, ", ", clear3, ", ")
	if error:
		if !time_starting:
			show_error = true
			timer.start()
			time_starting = true
		if show_error: error_img.show()
		else: error_img.hide()
	else: 
		timer.stop()
		show_error = false
		error = false
		time_starting = false
		error_img.hide()
	
	if check_all_clears() and !error:
		print("Winner")
	

func set_signs():
	if sign1 > 0:
		sign_img1.frame_coords = Vector2(sign1-1,1)
		sign_img1.show()
	if sign2 > 0:
		sign_img2.frame_coords = Vector2(sign2-1,1)
		sign_img2.show()
	if sign3 > 0:
		sign_img3.frame_coords = Vector2(sign3-1,1)
		sign_img3.show()


func _on_check_shapes_area_body_entered(body):
	if body.get_parent().is_in_group("shape_group"):
		if body.get_parent().texture_type == 0:
			print("Hold up")
		if body.get_parent().texture_type == sign1 and sign1 != 0:
			clear1 = true
		if body.get_parent().texture_type == sign2 and sign2 != 0:
			clear2 = true
		if body.get_parent().texture_type == sign3 and sign3 != 0:
			clear3 = true
#	check_all_clears()
	
func _on_no_allow_area_body_entered(body):
	if body.name == "magnet":
		return
	elif body.get_parent().is_in_group("shape_group"):
		error = true

func check_all_clears():
	if clear1: sign_img1.frame_coords.y = 0
	else: sign_img1.frame_coords.y = 1
	
	if clear2: sign_img2.frame_coords.y = 0
	else: sign_img2.frame_coords.y = 1
	
	if clear3: sign_img3.frame_coords.y = 0
	else: sign_img3.frame_coords.y = 1
	
	if clear1 and clear2 and clear3: return true
	else: return false


func _on_check_shapes_area_body_exited(body):
	if body.get_parent().is_in_group("shape_group"):
		if body.get_parent().texture_type == sign1 and sign1 != 0:
			clear1 = false
		if body.get_parent().texture_type == sign2 and sign2 != 0:
			clear2 = false
		if body.get_parent().texture_type == sign3 and sign3 != 0:
			clear3 = false
#	check_all_clears()


func _on_no_allow_area_body_exited(body):
	if body.name == "magnet":
		return
	elif body.get_parent().is_in_group("shape_group"):
		error = false


func _on_timer_timeout():
	show_error = !show_error
