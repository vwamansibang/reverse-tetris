extends CharacterBody2D

@export var texture_type : int = 0

@onready var ray_left = $ray_left
@onready var ray_right = $ray_right
@onready var ray_up = $ray_up
@onready var ray_down = $ray_down

@onready var texture = $Sprite2D

var append_str = ""
var ray_checks = [0, 0, 0, 0]
var dying = false

func _ready():
	texture.frame_coords.y = get_parent().texture_type
	var str = str(get_parent().name)
	append_str = str[-2] + str[-1]
	self.add_to_group("block"+append_str+"_group")

func _process(delta):
	
	if !auto.temp_pause: #May or may not be redundant but im not gonna check
		ray_checks = determine_parts()
	
	#determine texture
	var cnt = 0
	for check in ray_checks:
		if check == 1:
			cnt += 1
	
	if cnt < 2:
		texture.frame_coords.x = cnt
	elif cnt == 3:
		texture.frame_coords.x = 4
	elif cnt == 2:
		if ray_checks[0] == 1 and ray_checks[2] == 1:
			texture.frame_coords.x = 3
			texture.rotation_degrees = 90
		elif ray_checks[1] == 1 and ray_checks[3] == 1:
			texture.frame_coords.x = 3
			texture.rotation_degrees = 0
		else:
			texture.frame_coords.x = 2
			if ray_checks[0] == 1 and ray_checks[1] == 1:
				return
			elif ray_checks[1] == 1 and ray_checks[2] == 1:
				texture.rotation_degrees = 90
			elif ray_checks[2] == 1 and ray_checks[3] == 1:
				texture.rotation_degrees = 180
			elif ray_checks[3] == 1 and ray_checks[0] == 1:
				texture.rotation_degrees = 270
	else:
		texture.frame_coords.x = 0
		
	#determine rotation
	if cnt == 2 or cnt == 0:
		return	
	elif cnt == 1:
		texture.rotation_degrees = ray_checks.find(1) * 90
	elif cnt == 3:
		texture.rotation_degrees = ray_checks.find(0) * 90 + 180
	
		
	

func kill_yourself():
	dying = true
	var scene = load("res://test/block_explode.tscn")
	var instance = scene.instantiate()
	instance.global_position = position
	get_parent().add_child(instance)
	queue_free()

func determine_parts():
	if dying: return
	
	var ray_checks = [0, 0, 0, 0]
	if ray_left.is_colliding() and ray_left.get_collider() != null:
		if ray_left.get_collider().is_in_group("block"+append_str+"_group"):
			ray_checks[0] = 1
	if ray_right.is_colliding() and ray_right.get_collider() != null:
		if ray_right.get_collider().is_in_group("block"+append_str+"_group"):
			ray_checks[2] = 1
	if ray_up.is_colliding() and ray_up.get_collider() != null:
		if ray_up.get_collider().is_in_group("block"+append_str+"_group"):
			ray_checks[3] = 1
	if ray_down.is_colliding() and ray_down.get_collider() != null:
		if ray_down.get_collider().is_in_group("block"+append_str+"_group"):
			ray_checks[1] = 1
		
	return ray_checks
