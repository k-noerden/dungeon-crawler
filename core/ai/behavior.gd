class_name Behavior
extends Node2D
# @abstract # TODO: enable in 4.5

signal transitioned
var ai: AiComponent

func change_behavior(state_name: String) -> void:
	transitioned.emit(self, state_name)

func enter() -> void:
	pass

func exit() -> void:
	pass

func physics_update(delta: float) -> void:
	pass
