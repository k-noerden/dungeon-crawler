class_name TriggerAutomaticComponent
extends TriggerSemiAutomaticComponent

func _physics_process(delta: float) -> void:
	if not enabled:
		return
	timer += delta
	if Input.is_action_pressed("fire"):
		if timer > fire_rate:
			timer = 0;
			fire()
