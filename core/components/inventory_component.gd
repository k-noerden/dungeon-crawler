class_name InventoryComponent
extends Node2D

signal inventory_updated
var current_index = 0;
var weapons: Array[Node] = [null, null, null, null]

func _enter_tree() -> void:
	owner.set_meta("inventory", self)
func _exit_tree() -> void:
	owner.remove_meta("inventory")

func _ready() -> void:
	pass

func switch_to_next() -> void:
	current_index += 1
	if current_index >= weapons.size():
		current_index = 0
	switch_weapon()

func switch_to_previous() -> void:
	current_index -= 1
	if current_index < 0:
		current_index = weapons.size() - 1
	switch_weapon()

func switch_to(index: int) -> void:
	current_index = index
	switch_weapon()

func pickup_weapon(weapon: Node) -> void:
	drop_weapon()
	weapons[current_index] = weapon
	owner.current_weapon = weapon
	weapon.reparent(self)
	weapon.pickup(owner)
	weapon.equip()
	inventory_updated.emit()


func drop_weapon() -> void:
	if weapons[current_index] == null:
		return
	var weapon = weapons[current_index]
	weapons[current_index] = null
	owner.current_weapon = null
	weapon.reparent(Global.game)
	weapon.drop(owner)
	inventory_updated.emit()


func switch_weapon() -> void:
	inventory_updated.emit()
	if owner.current_weapon != null:
		owner.current_weapon.unequip()
		owner.current_weapon.hide()
	owner.current_weapon = weapons[current_index]
	if owner.current_weapon != null:
		owner.current_weapon.show()
		owner.current_weapon.equip()
