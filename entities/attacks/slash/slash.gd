extends Area2D

var moved_distance = 0
var velocity: Vector2
var damage: Damage
@export var animation_start: String = ""

func _ready() -> void:
	$AnimatedSprite2D.animation_looped.connect(die) # Mostly there to catch if developer did not turn off animation
	$AnimatedSprite2D.animation_finished.connect(die)
	assert($AnimatedSprite2D.sprite_frames.has_animation(animation_start), "Unknown Animation Start")
	$AnimatedSprite2D.play(animation_start)

func die():
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	var stats = body.get_meta("stats", false)
	if stats:
		stats.damage(damage)
