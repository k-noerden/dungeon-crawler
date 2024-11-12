extends Area2D

func _ready() -> void:
	$AnimatedSprite2D.animation_looped.connect(die)
	$AnimatedSprite2D.play("explosion")

func die():
	queue_free()
