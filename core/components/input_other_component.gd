class_name InputOtherComponent
extends Component

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("drop"):
		owner.get_meta("inventory").drop_weapon()
		var damage = Damage.new(10.0)
		owner.get_meta("stats").damage(damage)
	if event.is_action_pressed("interact"):
		owner.interact_action()
	if event.is_action_pressed("switch_to_0"):
		owner.get_meta("inventory").switch_to(0)
	if event.is_action_pressed("switch_to_1"):
		owner.get_meta("inventory").switch_to(1)
	if event.is_action_pressed("switch_to_2"):
		owner.get_meta("inventory").switch_to(2)
	if event.is_action_pressed("switch_to_3"):
		owner.get_meta("inventory").switch_to(3)
