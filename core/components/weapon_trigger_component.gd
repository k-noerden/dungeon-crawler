class_name WeaponTriggerComponent
extends Component

var component_name = "trigger"
enum TriggerType {SEMI, AUTO}
@export var trigger_type: TriggerType
@export var fire_rate = 1.0

var timer = 0

func trigger(initial: bool) -> void:
	if initial or trigger_type == TriggerType.AUTO:
		if timer > fire_rate:
			timer = 0
			owner.fire()

func _physics_process(delta: float) -> void:
	timer += delta
