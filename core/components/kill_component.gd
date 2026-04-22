@icon("res://assets/icons/configurable.svg")
class_name KillComponent
extends Node2D

func _ready() -> void:
	set_meta("is_action", self)

func action(who: Node2D) -> void:
	owner.queue_free()
