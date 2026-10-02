@icon("res://core/ui/editor/configurable.svg")
class_name UseItemComponent
extends TriggerSemiAutomaticComponent
# extends Node2D


@export var single_use = true
@export var local = false

func _enter_tree() -> void:
	owner.set_meta("trigger", self)
	for child in owner.get_children():
		if child is AnimatedSprite2D:
			animation = child
			break


func fire() -> void:
	print("Call UseItemComponent.fire")
	for child in get_children():
		if child.has_meta("is_action"):
			if local:
				print(owner)
				child.action(owner)
			else:
				print(owner.get_parent().owner)
				child.action(owner.get_parent().owner)
	if single_use:
		owner.get_parent().owner.get_meta("inventory").drop_item()
		owner.queue_free()
