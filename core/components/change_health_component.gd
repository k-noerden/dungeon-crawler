@icon("res://core/ui/editor/configurable.svg")
class_name ChangeHealthComponent
extends Node2D

@export var health = 10

func _ready() -> void:
	set_meta("is_action", self)

func action(who: Node2D) -> void:
	# print("ChangeHealthComponent.action ", who)
	# Global.player.get_meta("health").health += health
	who.get_meta("health").damage(-health)
