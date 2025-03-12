extends Area2D

@export var speed = 600
@export var range = 1000
var moved_distance = 0
var velocity: Vector2
var damage: Damage
@export var animation_start: String = ""
@export var animation_loop: String = ""

func _ready() -> void:
	velocity = Vector2.RIGHT.rotated(global_rotation) * speed
	assert(animation_start == "" or $AnimatedSprite2D.sprite_frames.has_animation(animation_start), "Unknown Animation Start")
	assert($AnimatedSprite2D.sprite_frames.has_animation(animation_loop), "Unknown Animation Loop")
	if animation_start:
		$AnimatedSprite2D.play(animation_start)
		$AnimatedSprite2D.animation_finished.connect(_on_animated_sprite_2d_animation_finished)
	else:
		$AnimatedSprite2D.play(animation_loop)

func _on_animated_sprite_2d_animation_finished() -> void:
	%AnimatedSprite2D.play(animation_loop)

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
