extends Node2D


func _draw():
	draw_polyline($Path2D.curve.get_baked_points(), Color.black, 5, false)
	draw_polyline($Path2D.curve.get_baked_points(), Color.white, 1, false)
