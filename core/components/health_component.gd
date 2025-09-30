@icon("res://assets/icons/configurable.svg")
class_name HealthComponent
extends Node2D

@export var max_health = 100.0

var health: float
signal health_changed(new_value, old_value)

func _enter_tree() -> void:
	owner.set_meta("health", self)

func _exit_tree() -> void:
	if owner:
		owner.remove_meta("health")

func _ready():
	health = max_health

func damage(damage: float) -> void:
	var old_health = health
	health -= damage
	if health < 0:
		health = 0
	if health > max_health:
		health = max_health
	health_changed.emit(health, old_health)
	if health <= 0:
		if owner.has_meta("die"):
			owner.get_meta("die").die()
		owner.queue_free()
