extends CharacterBody2D

@onready var axel = $axel
const SPEED = 240.0
const JUMP_VELOCITY = -480.0
const pull_up = 120

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var set_grav = false
var moving = false
var multiplier = -1

func _process(delta):
	axel.global_position.y = 48

func _physics_process(delta):
	velocity.y += gravity *multiplier * delta *1.45
	
	if is_on_ceiling():
		moving = false
	elif is_on_floor():
		moving = false
	else:
		moving = true
		
	if Input.is_action_just_pressed("ui_accept") and not moving:
		multiplier *= -1

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction and not moving:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
