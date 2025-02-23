extends Control

var player
var inventory
var icons = []
func _ready() -> void:
	player = get_node("/root/Game/Player")
	inventory = player.get_meta("inventory")
	var stats = player.get_meta("stats")
	stats.health_changed.connect(update_health_bar)
	stats_changed(stats)
	icons.push_back(%Inventory0)
	icons.push_back(%Inventory1)
	icons.push_back(%Inventory2)
	icons.push_back(%Inventory3)
	inventory_updated()
	inventory.inventory_updated.connect(inventory_updated)
	SignalBus.points_changed.connect(points_updated)


func stats_changed(stats) -> void:
	%HealthBar.value = stats.health
	%HealthBar.max_value = stats.max_health

func update_health_bar(new_value: float, old_value: float) -> void:
	%HealthBar.value = new_value

func inventory_updated() -> void:
	for i in range(inventory.weapons.size()):
		var weapon = inventory.weapons[i]
		if weapon == null:
			icons[i].texture = null
		else:
			var icon = inventory.weapons[i].get_meta("IconComponent")
			icons[i].texture = icon.icon if icon else inventory.weapons[i].icon
			#icons[i].get_parent().get_stylebox("panel").border_width_left = 3
	#print(icons[2].global_position)
	%Selected.global_position = icons[inventory.current_index].global_position


func points_updated(value: int, change: int) -> void:
	%Points.text = str(value)
