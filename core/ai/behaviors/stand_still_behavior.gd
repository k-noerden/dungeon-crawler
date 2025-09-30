class_name StandStillBehavior
extends Behavior

func enter() -> void:
	owner.velocity = Vector2.ZERO
	owner.get_meta("move").enabled = false
	owner.get_meta("move").move()
