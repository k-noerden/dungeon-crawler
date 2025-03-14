extends Node

var current_level: Node2D = null
var levels: Dictionary = {}

var navigation_region: NavigationRegion2D
func initialize() -> void:
	navigation_region = Global.game.get_node("NavigationRegion2D")
	#var top_left = Vector2(-10000, -10000)
	#var top_right = Vector2(10000, -10000)
	#var bottom_left = Vector2(-10000, 10000)
	#var bottom_right = Vector2(10000, 10000)
	#var polygon = NavigationPolygon.new()
	#var outline = PackedVector2Array([top_left, top_right, bottom_right, bottom_left])
	#polygon.add_outline(outline)
	#polygon.agent_radius = navigation_region.navigation_polygon.agent_radius
	#navigation_region.navigation_polygon = polygon
	#navigation_region.bake_navigation_polygon(false)

func change_to(level_name: String, player_destination: Vector2) -> void:
	var container = Global.game.find_child("CurrentLevel")
	var level
	if levels.has(level_name):
		level = levels[level_name]
	else:
		#var level_path = "res://levels/" + level_name + "/" + level_name + ".tscn"
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
