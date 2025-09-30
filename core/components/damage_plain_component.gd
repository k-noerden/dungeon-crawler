class_name DamagePlainComponent
extends Node2D

func _enter_tree() -> void:
	owner.set_meta("damage", self)

func _exit_tree() -> void:
	if owner:
		owner.remove_meta("damage")


func damage(body: Node2D) -> void:
	var damage = randf_range(owner.min_damage, owner.max_damage)
	var health = body.get_meta("health", false)
	if health:
		health.damage(damage)
