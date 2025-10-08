extends Node

func configure_templates(node: Node):
	for child in node.get_children():
		# if not child.has_meta("spawn"):
		# 	continue
		if child.has_meta("is_nonphysical"):
			continue
		child.hide()
		child.process_mode = PROCESS_MODE_DISABLED


func spawn(node: Node, position: Vector2, rotation: float, target: Node2D) -> void:
	var success = false
	for child in node.get_children():
		if child.has_meta("is_nonphysical"):
			continue
		if child.has_meta("is_action"):
			child.action(target)
			continue
		if child is CollisionShape2D:
			continue
		success = true
		var template = child
		var instance = template.duplicate()
		instance.global_position = position
		instance.global_rotation = rotation
		instance.show()
		instance.process_mode = PROCESS_MODE_INHERIT
		LevelLoader.current_level.add_child(instance)
		if "target" in instance: # instance has attribute `target`
			# instance.target = target
			instance.set("target", target)
		var spawn_component = instance.get_meta("spawn", false)
		if spawn_component:
			spawn_component.spawn()
	# assert(success, "Nothing spawned")
