class_name StatsComponent
extends Component

var component_name = "stats"

signal health_changed(new_value, old_value)

@export var max_health = 100.0
var health: float
@export var hurt_sound: AN.Sound = AN.Sound.NO_SOUND
@export var die_sound: AN.Sound = AN.Sound.NO_SOUND

func _ready():
	health = max_health

func damage(damage: Damage) -> float:
	var total_damage = 0.0;
	total_damage += damage.plain
	total_damage += damage.fire
	var old_health = health
	health -= total_damage
	health_changed.emit(health, old_health)
	if health < 0:
		if owner.has_method("die"):
			owner.die()
		if owner.has_meta("DieComponent"):
			owner.get_meta("DieComponent").die()
		Audio.play(die_sound, owner.global_position)
	else:
		Audio.play(hurt_sound, owner.global_position)
	return total_damage
