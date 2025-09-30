@icon("res://assets/icons/configurable.svg")
class_name DurationCondition
extends Node2D

@export var next_behavior: String
@export var duration = 1.0


func _ready() -> void:
	self.set_meta("is_nonphysical", self)


func condition(ai: AiComponent) -> bool:
	if ai.duration > duration:
		return true
	return false
