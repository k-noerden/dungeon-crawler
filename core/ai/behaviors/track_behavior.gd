@icon("res://assets/icons/configurable.svg")
class_name TrackBehavior
extends Behavior

@export var speed = 100.0

func enter() -> void:
	owner.get_meta("move").speed = speed
	owner.get_meta("move").enabled = true

func physics_update(delta: float) -> void:
	owner.get_meta("move").navigation_agent.target_position = ai.target.global_position
