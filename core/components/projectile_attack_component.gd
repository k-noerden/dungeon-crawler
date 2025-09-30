@icon("res://assets/icons/configurable.svg")
class_name ProjectileAttackComponent
extends Node2D

@export var start_animation = ""
@export var loop_animation = ""

var moved_distance = 0
var velocity: Vector2
var animation: AnimatedSprite2D

func _enter_tree() -> void:
	owner.set_meta("spawn", self)
	animation = owner.find_child("AnimatedSprite2D")
	assert(animation)
	assert(start_animation == "" or animation.sprite_frames.has_animation(start_animation), "Unknown Animation Start")
	assert(animation.sprite_frames.has_animation(loop_animation), "Unknown Animation Loop")

func _exit_tree() -> void:
	if owner:
		owner.remove_meta("spawn")


func spawn() -> void:
	# Global.ephemeral.add_child(owner)
	owner.reparent(Global.ephemeral)
	velocity = Vector2.RIGHT.rotated(global_rotation) * owner.speed
	if start_animation:
		animation.play(start_animation)
		animation.animation_finished.connect(_on_animated_sprite_2d_animation_finished)
	else:
		animation.play(loop_animation)
	owner.body_entered.connect(_on_body_entered)

func _on_animated_sprite_2d_animation_finished() -> void:
	animation.play(loop_animation)

func _physics_process(delta: float) -> void:
	owner.position += velocity * delta
	moved_distance += owner.speed * delta
	if moved_distance > owner.range:
		owner.queue_free()


func _on_body_entered(body: Node2D) -> void:
	owner.get_meta("damage").damage(body)
	owner.queue_free()
