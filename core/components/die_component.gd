@icon("res://assets/icons/configurable.svg")
class_name DieComponent
extends Node2D

func _enter_tree() -> void:
	owner.set_meta("die", self)
	Utils.configure_templates(self)

func _exit_tree() -> void:
	if owner:
		owner.remove_meta("die")


func die() -> void:
	Utils.spawn(self, global_position, 0.0, null)
