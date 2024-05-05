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
var texture_safe = false
var north_ray = null

var do_once = false

var motion = Vector2.ZERO

func _ready():	
	texture.frame_coords.y = get_parent().texture_type
	var str = str(get_parent().name)
	append_str = str[-2] + str[-1]
	self.add_to_group("block"+append_str+"_group")
	
	ray_left.add_to_group("ray"+append_str+"_group")
	ray_down.add_to_group("ray"+append_str+"_group")
	ray_right.add_to_group("ray"+append_str+"_group")
	ray_up.add_to_group("ray"+append_str+"_group")
	
	ray_checks = determine_parts()
	determine_texture(ray_checks)
	set_north()

func _process(delta):
	if !do_once:
		set_north()
	do_once = true
	check_above()
#	if !auto.temp_pause: #May or may not be redundant but im not gonna check
#	if !texture_safe:
	if ray_checks == determine_parts():
		return
	ray_checks = determine_parts()
	determine_texture(ray_checks)
		
	

func kill_yourself():
	dying = true
	texture_safe = false
	
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
	
func determine_texture(ray_checks):
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
	
func check_above():
	if north_ray == null:
		return
	if north_ray.is_colliding() and north_ray.get_collider().is_in_group("block_group"):
		if !north_ray.get_collider().is_in_group("block"+append_str+"_group"):
			get_parent().check_if_under = true
		else:
			get_parent().check_if_under = false
	else:
		get_parent().check_if_under = false

func set_north():
	if roundi(get_parent().rotation_degrees) == 0:
		north_ray = ray_up
	elif roundi(get_parent().rotation_degrees) == 90:
		north_ray = ray_right
	elif roundi(get_parent().rotation_degrees) == 180:
		north_ray = ray_down
	elif roundi(get_parent().rotation_degrees) == 270:
		north_ray = ray_left
		
#	print(get_parent().name, ": ", north_ray)
func easy_access():
	ray_checks = determine_parts()
	determine_texture(ray_checks)
