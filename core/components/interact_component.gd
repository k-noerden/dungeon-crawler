class_name InteractComponent
extends Node2D

func _enter_tree() -> void:
	owner.set_meta("interact", self)
	Utils.configure_templates(self)

func _exit_tree() -> void:
	if owner:
		owner.remove_meta("interact")

func interact(who: Node2D) -> bool:
	Utils.spawn(self, Vector2.ZERO, 0.0, who)
	return true
