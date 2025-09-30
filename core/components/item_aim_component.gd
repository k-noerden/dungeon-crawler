class_name ItemAimComponent
extends Node2D

var target = Vector2.ZERO
var _enabled = false

var animation: AnimatedSprite2D
var pivot: Node2D
var hold: Node2D

func _enter_tree() -> void:
	owner.set_meta("aim", self)
	for child in owner.get_children():
		if child is AnimatedSprite2D:
			animation = child
			break
	pivot = get_node("Pivot")
	hold = pivot.get_node("Hold")

func _exit_tree() -> void:
	if owner:
		owner.remove_meta("aim")


func enable() -> void:
	_enabled = true
	animation.reparent(hold)
	animation.position = Vector2.ZERO

func disable() -> void:
	_enabled = false
	pivot.rotation = 0.0
	animation.reparent(owner)
	animation.position = Vector2.ZERO
	animation.flip_v = false

func _physics_process(delta: float) -> void:
	if _enabled:
		var target = owner.get_global_mouse_position()
		pivot.look_at(target)
		if pivot.global_rotation < -PI / 2.0 or pivot.global_rotation > PI / 2.0:
			animation.flip_v = true
		else:
			animation.flip_v = false
