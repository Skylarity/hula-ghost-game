extends PathFollow2D

export var speed = 0.01

func _ready():
	unit_offset = 1  # start at end of line

func _process(delta):
	unit_offset -= speed  # move backwards

	if unit_offset <= speed:
		queue_free()  #delete when at beginning of line
