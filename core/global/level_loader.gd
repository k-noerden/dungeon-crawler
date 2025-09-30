extends Node


var current_level: Node2D = null
var levels: Dictionary = {}
var navigation_region: NavigationRegion2D

func initialize() -> void:
	navigation_region = Global.game.get_node("NavigationRegion2D")

func change_to(level_name: String, player_destination: Vector2) -> void:
	var container = Global.game.get_node("CurrentLevel")
	var level
	if levels.has(level_name):
		level = levels[level_name]
	else:
		var level_path = "res://levels/" + level_name + ".tscn"
		level = load(level_path).instantiate()
		levels[level_name] = level
	Global.player.global_position = player_destination
	if level == current_level:
		return
	if current_level != null:
		container.remove_child(current_level)
	current_level = level
	container.add_child(level)
	#call_deferred("bake")
	#bake()
	for node in Global.ephemeral.get_children():
		node.queue_free()

func bake() -> void:
	#await get_tree().physics_frame
	print("baking")
	navigation_region.bake_navigation_polygon(true)
	print("baked")
