extends Area2D

var moved_distance = 0
var velocity: Vector2
var damage: Damage

func _ready() -> void:
	$AnimatedSprite2D.animation_looped.connect(die)
	$AnimatedSprite2D.play("slash")

func die():
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	var stats = body.get_meta("stats", false)
	if stats:
		stats.damage(damage)
