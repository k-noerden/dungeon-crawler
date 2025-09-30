@icon("res://assets/icons/configurable.svg")
class_name TrackLastSeenBehavior
extends Behavior

@export var target: Node2D
@export var speed = 100.0
@export var lost_track_behavior: String

func enter() -> void:
	owner.get_meta("move").speed = speed
	owner.get_meta("move").enabled = true

func physics_update(delta: float) -> void:
	owner.get_meta("move").navigation_agent.target_position = ai.last_seen_target_position
	if global_position.distance_to(ai.last_seen_target_position) < 10:
		change_behavior(lost_track_behavior)
