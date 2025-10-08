@icon("res://assets/icons/configurable.svg")
class_name ChangePointsComponent
extends Node2D

@export var points = 1

func _ready() -> void:
	set_meta("is_action", self)


func action(who: Node2D) -> void:
	Global.points += points
	Global.points_changed.emit(Global.points, points)
