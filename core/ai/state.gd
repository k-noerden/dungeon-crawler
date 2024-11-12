class_name State
extends Node2D

signal transitioned
var state_machine: StateMachineComponent

func change_state(state_name: String) -> void:
	transitioned.emit(self, state_name, self)

func enter(detector: Node) -> void:
	pass

func exit() -> void:
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	pass
