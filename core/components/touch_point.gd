@icon("res://assets/icons/configurable.svg")
class_name TouchPoint
extends Area2D

@export var points = 1
@export var die_on_touch = true

func _enter_tree() -> void:
	owner.set_meta("touch", self)

func _exit_tree() -> void:
	if owner:
		owner.remove_meta("touch")

func _ready() -> void:
	area_entered.connect(on_touch)

func on_touch(who: Node2D):
	Global.points += points
	Global.points_changed.emit(Global.points, points)
	if die_on_touch:
		owner.queue_free()
