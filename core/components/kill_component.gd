@icon("res://assets/icons/configurable.svg")
class_name KillComponent
extends Node

func _ready() -> void:
	set_meta("is_action", self)

func action(who: Node2D) -> bool:
	owner.queue_free()
