extends Node2D

@onready var press_start = $CanvasLayer/press_start
@onready var all_the_shit = $intro
@onready var options_ui = $buttons_and_shit/title_ui
@onready var hud = $buttons_and_shit

var already_in_left = false
var already_in_level = false
var already_in_option = false
var prevent_repeat = false
@export var intro_done = false
var default_pos = Vector2.ZERO

func anim_fall_down():
	$AnimationPlayer.play("fall_down")

func anim_pull_up():
	$AnimationPlayer.play("pull_up")
	
func _ready():
	default_pos = all_the_shit.position
	
func _process(delta):
	if !prevent_repeat:
		if press_start.is_visible_in_tree() and Input.is_action_just_pressed("start"):
			if !intro_done:
				return
			move_left()
			press_start.hide()
			
		if Input.is_action_just_pressed("back"):
			if already_in_left:
				if already_in_level:
					return_to_menu()
				else:
					move_right()
					press_start.show()
			

func move_left():
	if already_in_left or prevent_repeat or already_in_level:
		return
	already_in_left = true
	prevent_repeat = true
	
	var tween = create_tween().set_parallel(true)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(all_the_shit, "position", default_pos + Vector2(-48, 0), 0.5)
	
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property(hud, "offset", Vector2.ZERO, 0.5)
	options_ui.allow(true)
	
	await tween.finished
	prevent_repeat = false

func move_right():
	if !already_in_left or prevent_repeat or already_in_level:
		return
	already_in_left = false
	prevent_repeat = true
	
	var tween = create_tween().set_parallel(true)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(all_the_shit, "position", default_pos, 0.5)
	tween.tween_property(hud, "offset", Vector2(24, 0), 0.5)
	options_ui.deselect()
	
	await tween.finished
	prevent_repeat = false

func move_up():
	if already_in_level or prevent_repeat:
			return
	already_in_level = true
	prevent_repeat = true
	
	var tween = create_tween().set_parallel(true)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property(all_the_shit, "position", default_pos + Vector2(-48, 192), 0.5)
	
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property(hud, "offset", Vector2(0, 192), 0.5)
	options_ui.allow(true)
	
	await tween.finished
	prevent_repeat = false
	#walang kwentang ama na hindi maaasahan, puro dismaya at takot lang ang mabibigay
	#ang nagdedesisyon sa kinabukasan ko ay isang sira ulong mayabang
	#hinihila kami pababa para lang mapatunayan niya na mas magaling sya kina tito at tita
	#palaging kasalanan namin nina mama, at hindi sa delusyonal na pangarap niya
	#Siya ang dahilan bakit hindi nalulutas ang mga problema 
func return_to_menu():
	if !already_in_level or prevent_repeat:
		return
	already_in_level = false
	prevent_repeat = true
	
	var tween = create_tween().set_parallel(true)
	tween.set_ease(Tween.EASE_OUT)
	
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property(all_the_shit, "position", default_pos + Vector2(-48, 0), 0.5)
	
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property(hud, "offset", Vector2(0, 0), 0.5)
	options_ui.allow(true)
	
	await tween.finished
	prevent_repeat = false
	
func _on_title_button_pressed():
	move_up()
