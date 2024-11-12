class_name TargetSeenDetector
extends Node2D

@export var next_state: String
@export var negated = false
@export var max_distance = 100
var target: Node2D

func prepare(state_machine: StateMachineComponent) -> void:
	if state_machine.target == null:
		state_machine.target = Global.player

func detect_state_change(state_machine: StateMachineComponent) -> bool:
	if global_position.distance_to(state_machine.target.global_position) <= max_distance:
		if state_machine.is_target_visible:
			#Audio.play(sound, owner.global_position)
			return !negated
	return negated
