extends Node2D


func _draw():
	draw_polyline($Path2D.curve.get_baked_points(), Color.darkslategray, 12, false)
	draw_polyline($Path2D.curve.get_baked_points(), Color.white, 5, false)
