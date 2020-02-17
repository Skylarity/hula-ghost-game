extends Area2D

export var animation_intensity = 3

func _process(delta):
	$AnimatedSprite.position = Vector2(0, sin(OS.get_ticks_msec() / 100) * animation_intensity)
