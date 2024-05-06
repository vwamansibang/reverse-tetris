extends CharacterBody2D

@onready var axel = $axel
@onready var ray_left = $left
@onready var ray_right = $right
@onready var ray_down = $down

const SPEED = 240.0
const JUMP_VELOCITY = -240.0
const pull_up = 120

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var set_grav = false
var moving = false
var multiplier = -1
var prevent_repeat = false

var stick = false
var attached_obj = null
var carry_vector = Vector2.ZERO
var ready_to_drop = false
var object_released = false

func _process(delta):
	axel.global_position.y = 48
	
	if not moving and is_on_ceiling():
		if Input.is_action_just_pressed("ui_left") and !ray_left.is_colliding():
			move_horizontal(-1)
		if Input.is_action_just_pressed("ui_right") and !ray_right.is_colliding():
			move_horizontal(1)
	
	# DETECT MAGNETISM
	if ray_down.is_colliding() and ray_down.get_collider() != null:
		if ray_down.get_collider().get_parent().check_if_under:
				multiplier = -1
				stick = false
				return
		if ray_down.get_collider().is_in_group("block_group") and !stick:
			stick = true
			attached_obj = ray_down.get_collider()
			
			auto.magnet_vector_data = position
			auto.shape_vector_data = attached_obj.get_parent().position
			auto.shape_rotation_data =  attached_obj.get_parent().rotation
			auto.shape_type_data = attached_obj.get_parent().shape_file
			auto.shape_texture_data = attached_obj.get_parent().texture_type
			
			attach_object(attached_obj)

func _physics_process(delta):
	if multiplier == -1:
		velocity.y += gravity *multiplier * delta *0.75
	elif multiplier == 1:
		velocity.y += gravity *multiplier * delta *1.8
		
	if Input.is_action_just_pressed("ui_accept") and not moving:
		multiplier *= -1
#		if get_tree().get_nodes_in_group("block_group").size() > 0:
#			get_tree().get_nodes_in_group("block_group").pick_random().get_parent().kill_yourself()
	move_and_slide()
	
	if is_on_ceiling():
		moving = false
		if object_released:
			stick = false
			ready_to_drop = false
			object_released = false
		if stick:
			ready_to_drop = true
	elif is_on_floor():
		moving = false
		if ready_to_drop and !object_released:
			multiplier = -1
			release_object()
			object_released = true
	else:
		moving = true

func move_horizontal(direction):
	if prevent_repeat:
		return
	prevent_repeat = true
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CIRC)
	tween.tween_property(self, "position", position+Vector2(16*direction, 0), 0.16)
	await tween.finished
	prevent_repeat = false
	
func attach_object(obj):
	var shape_scene = load("res://test/block_shape.tscn")
	var texture_scene = load("res://test/block_texture.tscn")
#	var gap = to_local(obj.global_position) - position
	for block in obj.get_parent().get_children():
		var texture_instance = texture_scene.instantiate()
		texture_instance.position = to_local(block.global_position)
		texture_instance.frame_coords = block.texture.frame_coords
		texture_instance.rotation_degrees = block.texture.rotation_degrees + block.get_parent().rotation_degrees
		texture_instance.add_to_group("temp_group")
		add_child(texture_instance)
		
		var shape_instance = shape_scene.instantiate()
		shape_instance.position = to_local(block.global_position)
		shape_instance.add_to_group("temp_group")
		add_child(shape_instance)
	obj.get_parent().queue_free()
	
func release_object():
	var saved_scene = auto.shape_type_data
	var saved_instance = saved_scene.instantiate()
	var gap = position - auto.magnet_vector_data

	saved_instance.position = auto.shape_vector_data + gap
	saved_instance.rotation = auto.shape_rotation_data
	saved_instance.texture_type = auto.shape_texture_data
	saved_instance.add_to_group("shape_group")
	get_parent().add_child(saved_instance)
	
	get_tree().call_group("temp_group", "queue_free")
	auto.reset_vector_data()
	attached_obj = null
