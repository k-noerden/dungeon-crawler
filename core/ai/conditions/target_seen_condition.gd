@icon("res://assets/icons/configurable.svg")
class_name TargetSeenDetector
extends Node2D

@export var next_behavior: String
@export var negated = false
@export var max_distance = 100


func _ready() -> void:
	self.set_meta("is_nonphysical", self)

# func prepare(ai: AiComponent) -> void:
# 	if ai.target == null:
# 		ai.target = Global.player

func condition(ai: AiComponent) -> bool:
	if global_position.distance_to(ai.target.global_position) <= max_distance:
		if ai.is_target_visible:
			return !negated
	return negated
