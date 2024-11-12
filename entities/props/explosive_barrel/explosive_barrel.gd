extends StaticBody2D

func die() -> void:
	queue_free()
	const Explosion = preload("res://entities/attacks/explosion/explosion.tscn")
	var explosion = Explosion.instantiate()
	explosion.global_position = global_position
	Global.ephemeral.add_child(explosion)
