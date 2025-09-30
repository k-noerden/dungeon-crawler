extends Node2D

func _physics_process(delta: float) -> void:
	if Global.current_weapon == null:
		return
	# Global.current_weapon.target = owner.get_global_mouse_position()
	if Input.is_action_just_pressed("fire"):
		Global.current_weapon.get_meta("trigger").trigger(true)
	elif Input.is_action_pressed("fire"):
		Global.current_weapon.get_meta("trigger").trigger(false)
