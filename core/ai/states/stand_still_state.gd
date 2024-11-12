class_name StandStillState
extends State

func enter(detector: Node) -> void:
	owner.velocity = Vector2.ZERO
	owner.get_meta("MoveComponent").enabled = false
	owner.get_meta("MoveComponent").move()
