extends Area2D

signal player_hit


func _on_Player_area_entered(area):
	area.on_player_hit()
