class_name InputAimComponent
extends Component

func _physics_process(delta: float) -> void:
	if owner.current_weapon == null:
		return
	owner.current_weapon.target = owner.get_global_mouse_position()
	if Input.is_action_just_pressed("fire"):
		owner.current_weapon.get_meta("trigger").trigger(true)
	elif Input.is_action_pressed("fire"):
		owner.current_weapon.get_meta("trigger").trigger(false)
