@icon("res://assets/icons/configurable.svg")
class_name TextComponent
extends Label

@export var duration = 5.0;

func _enter_tree() -> void:
	owner.set_meta("interact", self)
	assert("text" in owner, "Owner must have a text property")
	assert(owner.text != "", "Owner must have some actual text")
	text = owner.text
	hide()

func _exit_tree() -> void:
	if owner:
		owner.remove_meta("interact")

func interact(who: Node2D) -> bool:
	if visible:
		hide()
	else:
		show()
		get_tree().create_timer(duration).timeout.connect(hide)
	return true
