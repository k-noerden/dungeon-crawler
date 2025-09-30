@icon("res://assets/icons/configurable.svg")
extends Node2D

@export var map: String
@export var coordinate: Vector2

func _ready() -> void:
	set_meta("interact", self)

func interact(_who: Node2D) -> bool:
	LevelLoader.change_to(map, coordinate)
	return true
