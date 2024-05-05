extends AnimatedSprite2D

func _on_animation_looped():
	auto.temp_pause = false
	queue_free()
