@icon("res://assets/icons/configurable.svg")
class_name TouchComponent
extends Area2D

@export var remove_on_touch = true

func _enter_tree() -> void:
	owner.set_meta("touch", self)

func _exit_tree() -> void:
	if owner:
		owner.remove_meta("touch")

func _ready() -> void:
	area_entered.connect(on_touch)
	Utils.configure_templates(self)


func on_touch(who: Node2D):
	Utils.spawn(self, Vector2.ZERO, 0.0, who)
	if remove_on_touch:
		owner.queue_free()
