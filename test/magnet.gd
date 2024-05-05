extends CharacterBody2D

@onready var axel = $axel
@onready var ray_left = $left
@onready var ray_right = $right
@onready var ray_down = $down

const SPEED = 240.0
const JUMP_VELOCITY = -480.0
const pull_up = 120

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var set_grav = false
var moving = false
var multiplier = -1
var prevent_repeat = false

var stick = false

func _process(delta):
	axel.global_position.y = 48
	
	if not moving and is_on_ceiling():
		if Input.is_action_just_pressed("ui_left") and !ray_left.is_colliding():
			move_horizontal(-1)
		if Input.is_action_just_pressed("ui_right") and !ray_right.is_colliding():
			move_horizontal(1)
	
	if ray_down.is_colliding():
		if ray_down.get_collider().get_parent().is_in_group("shape_group"):
			stick = true
		pass

func _physics_process(delta):
	if multiplier == -1:
		velocity.y += gravity *multiplier * delta *0.6
	elif multiplier == 1:
		velocity.y += gravity *multiplier * delta *1.72
	
	if is_on_ceiling():
		moving = false
	elif is_on_floor():
		moving = false
	else:
		moving = true
		
	if Input.is_action_just_pressed("ui_accept") and not moving:
		multiplier *= -1
		
#		if get_tree().get_nodes_in_group("block_group").size() > 0:
#			get_tree().get_nodes_in_group("block_group").pick_random().get_parent().kill_yourself()

	move_and_slide()

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
	
