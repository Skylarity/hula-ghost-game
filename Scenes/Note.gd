extends Area2D

export (PackedScene) var NoteParticles

func on_player_hit():
	var particles = NoteParticles.instance()
	particles.position = get_parent().position
	get_tree().get_root().get_node("PlayArea").add_child(particles)
	queue_free()
