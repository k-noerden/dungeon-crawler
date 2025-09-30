extends Control

var inventory
var icons = []

func _ready() -> void:
	var player = get_node("/root/Game/Player")
	inventory = player.get_meta("inventory")
	var player_health = player.get_meta("health")
	player_health.health_changed.connect(health_changed)
	%HealthBar.value = player_health.health
	%HealthBar.max_value = player_health.max_health
	icons.push_back(%Inventory0)
	icons.push_back(%Inventory1)
	icons.push_back(%Inventory2)
	icons.push_back(%Inventory3)
	inventory.inventory_updated.connect(inventory_updated)
	Global.points_changed.connect(points_changed)
	inventory_updated()

func health_changed(new_value: float, old_value: float) -> void:
	%HealthBar.value = new_value

func inventory_updated() -> void:
	for i in range(inventory.items.size()):
		var item = inventory.items[i]
		if item == null:
			icons[i].texture = null
		else:
			var texture = item.animation.sprite_frames.get_frame_texture(item.inventory_animation, 0)
			icons[i].texture = texture
	%Selected.global_position = icons[inventory.current_index].global_position

func points_changed(value: int, change: int) -> void:
	%Points.text = str(value)
