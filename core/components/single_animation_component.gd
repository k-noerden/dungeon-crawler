@icon("res://assets/icons/configurable.svg")
class_name SingleAnimationComponent
extends Node2D

@export var animation = ""
var _animation: AnimatedSprite2D


func _enter_tree() -> void:
	self.set_meta("is_action", self)
	self._animation = owner.get_node("AnimatedSprite2D")
	assert(animation, "No animation selected")
	assert(_animation.sprite_frames.has_animation(animation), "Missing animation in " + str(owner))
	hide()

func action(target) -> void:
	owner.remove_child(_animation)
	_animation.global_position = owner.global_position + _animation.position
	LevelLoader.current_level.add_child(_animation)
	_animation.play(animation)
	_animation.animation_finished.connect(_animation.queue_free)
	_animation.animation_looped.connect(_animation.queue_free)
