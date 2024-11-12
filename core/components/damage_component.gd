class_name DamageComponent
extends Component

@export var min_plain = 0.0
@export var max_plain = 0.0
@export var min_fire = 0.0
@export var max_fire = 0.0

func make_damage() -> Damage:
	var damage = Damage.new()
	damage.plain = randf_range(min_plain, max_plain)
	damage.fire = randf_range(min_fire, max_fire)
	return damage
