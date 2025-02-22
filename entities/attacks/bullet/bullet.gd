extends Area2D

var speed = 600
var range = 1000
var moved_distance = 0
var velocity: Vector2
var damage: Damage

func _ready() -> void:
	velocity = Vector2.RIGHT.rotated(global_rotation) * speed

func _physics_process(delta: float) -> void:
	position += velocity * delta
	moved_distance += speed * delta
	if moved_distance > range:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	var stats = body.get_meta("stats", false)
	if stats:
		stats.damage(damage)
	queue_free()
