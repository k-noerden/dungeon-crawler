@icon("res://assets/icons/configurable.svg")
class_name ItemComponent
extends Area2D

@export var ground_animation: String
@export var inventory_animation: String
# @export var equip_animation: String
# @export var idle_animation: String
# @export var fire_animation: String

enum State {GROUNDED, HELD, INVENTORY}
var state = State.GROUNDED
var animation: AnimatedSprite2D

func _enter_tree() -> void:
	owner.set_meta("item", self)
	owner.set_meta("interact", self)
	for child in owner.get_children():
		if child is AnimatedSprite2D:
			animation = child
			break
	assert(animation.sprite_frames.has_animation(ground_animation), "Missing ground animation in " + str(owner))
	assert(animation.sprite_frames.has_animation(inventory_animation), "Missing inventory animation in " + str(owner))
	# assert(equip_animation == "" or animation.sprite_frames.has_animation(equip_animation), "Missing equip animation in " + str(owner))
	# assert(animation.sprite_frames.has_animation(idle_animation), "Missing idle animation in " + str(owner))
	# assert(animation.sprite_frames.has_animation(fire_animation), "Missing fire animation in " + str(owner))
	animation.play(ground_animation)

func _exit_tree() -> void:
	owner.remove_meta("item")
	owner.set_meta("interact", self)


func interact(who: Node2D) -> bool:
	who.get_meta("inventory").pickup_item(self)
	return true

func pickup(holder: Node2D) -> void:
	state = State.INVENTORY
	owner.position = Vector2.ZERO
	get_node("CollisionShape2D").set_deferred("disabled", true)


func drop(holder: Node2D) -> void:
	state = State.GROUNDED
	get_node("CollisionShape2D").set_deferred("disabled", false)
	owner.global_position = holder.global_position + (global_position - animation.global_position) + Vector2(0, 8)

func equip() -> void:
	state = State.HELD
	# if equip_animation:
	# 	animation.play(equip_animation)
	var aim = owner.get_meta("aim")
	if aim:
		aim.enable()
	owner.get_meta("trigger").enable()

func unequip() -> void:
	state = State.INVENTORY
	var aim = owner.get_meta("aim")
	if aim:
		aim.disable()
	owner.get_meta("trigger").disable()
