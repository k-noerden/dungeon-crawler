@icon("res://assets/icons/configurable.svg")
class_name AreaAttackComponent
extends Node2D

@export var selected_animation = ""

var animation: AnimatedSprite2D

func _enter_tree() -> void:
	owner.set_meta("spawn", self)
	animation = owner.find_child("AnimatedSprite2D")
	assert(animation.sprite_frames.has_animation(selected_animation), "Unknown selected animation")

func _exit_tree() -> void:
	if owner:
		owner.remove_meta("spawn")

func spawn() -> void:
	# Global.ephemeral.add_child(owner)
	owner.reparent(Global.ephemeral)
	animation.animation_finished.connect(on_animation_finished)
	animation.animation_looped.connect(on_animation_finished) # Mostly there to catch if developer did not turn off animation
	animation.play(selected_animation)
	owner.body_entered.connect(on_body_entered)

func on_animation_finished() -> void:
	owner.queue_free()

func on_body_entered(body: Node2D) -> void:
	owner.get_meta("damage").damage(body)
