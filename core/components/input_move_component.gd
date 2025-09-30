@icon("res://assets/icons/configurable.svg")
class_name InputMoveComponent
extends Node

@export var speed = 200
@export var idle_animation: String
@export var run_animation: String

var animation: AnimatedSprite2D


func _enter_tree() -> void:
	for child in owner.get_children():
		if child is AnimatedSprite2D:
			animation = child
			break
	assert(animation.sprite_frames.has_animation(idle_animation), "Missing idle animation in " + str(owner))
	assert(animation.sprite_frames.has_animation(run_animation), "Missing run animation in " + str(owner))


func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	owner.velocity = direction * speed
	owner.move_and_slide()
	if owner.velocity.length() > 0:
		animation.play(run_animation)
		animation.flip_h = owner.velocity.x < 0
	else:
		animation.play(idle_animation)
