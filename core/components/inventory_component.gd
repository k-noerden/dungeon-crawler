class_name InventoryComponent
extends Node2D

signal inventory_updated
var current_index = 0
var items: Array[Node] = [null, null, null, null]

func _enter_tree() -> void:
	owner.set_meta("inventory", self)

func _exit_tree() -> void:
	if owner:
		owner.remove_meta("inventory")


func switch_to_next() -> void:
	current_index += 1
	if current_index >= items.size():
		current_index = 0
	switch_item()

func switch_to_previous() -> void:
	current_index -= 1
	if current_index < 0:
		current_index = items.size() - 1
	switch_item()

func switch_to(index: int) -> void:
	current_index = index
	switch_item()

func switch_item() -> void:
	inventory_updated.emit()
	if Global.current_item != null:
		Global.current_item.unequip()
		Global.current_item.owner.hide()
	Global.current_item = items[current_index]
	if Global.current_item != null:
		Global.current_item.owner.show()
		Global.current_item.equip()


func pickup_item(item: Node) -> void:
	drop_item()
	items[current_index] = item
	Global.current_item = item
	item.owner.reparent(self)
	item.pickup(owner)
	item.equip()
	inventory_updated.emit()


func drop_item() -> void:
	if items[current_index] == null:
		return
	var item = items[current_index]
	items[current_index] = null
	Global.current_item = null
	item.owner.reparent(LevelLoader.current_level)
	item.unequip()
	item.drop(owner)
	inventory_updated.emit()
