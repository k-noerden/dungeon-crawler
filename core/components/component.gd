class_name Component
extends Node

#var component_name = get_script().get_global_name()


func _enter_tree() -> void:
	var component_name = get("component_name")
	if component_name == null:
		component_name = get_script().get_global_name()
	owner.set_meta(component_name, self)


func _exit_tree() -> void:
	var component_name = get("component_name")
	if component_name == null:
		component_name = get_script().get_global_name()
	if owner != null: # owner will be freed before children
		owner.remove_meta(component_name)
