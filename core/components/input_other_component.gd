class_name InputOtherComponent
extends Node2D


var area: Area2D;
func _enter_tree() -> void:
	for child in get_children():
		if child is Area2D:
			area = child
			break


func interact_action() -> void:
	var areas = area.get_overlapping_areas()
	for area in areas:
		var other = area.owner
		if other.has_meta("interact"):
			if other.get_meta("interact").interact(owner):
				break


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		interact_action()
	elif event.is_action_pressed("drop"):
		owner.get_meta("inventory").drop_item()
	elif event.is_action_pressed("switch_to_0"):
		owner.get_meta("inventory").switch_to(0)
	elif event.is_action_pressed("switch_to_1"):
		owner.get_meta("inventory").switch_to(1)
	elif event.is_action_pressed("switch_to_2"):
		owner.get_meta("inventory").switch_to(2)
	elif event.is_action_pressed("switch_to_3"):
		owner.get_meta("inventory").switch_to(3)
