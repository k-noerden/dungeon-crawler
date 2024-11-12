class_name TrackState
extends State

@export var speed = 100.0

func enter(detector: Node) -> void:
	if state_machine.target == null:
		state_machine.target = Global.player
	owner.get_meta("MoveComponent").speed = speed
	owner.get_meta("MoveComponent").enabled = true

func physics_update(delta: float) -> void:
	owner.get_meta("MoveComponent").target_position = state_machine.target.global_position
