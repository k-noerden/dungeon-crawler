@icon("res://assets/icons/configurable.svg")
class_name ChangeHealthComponent
extends Node2D

@export var health = 10

func _ready() -> void:
	set_meta("is_action", self)

func action(who: Node2D) -> void:
	Global.player.get_meta("stats").health += health
