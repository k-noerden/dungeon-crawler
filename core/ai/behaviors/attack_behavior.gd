@icon("res://assets/icons/configurable.svg")
class_name AttackBehavior
extends Behavior

enum BetweenShotsBehavior {STAY, MOVE_CLOSER}

@export var min_attack_delay = 4.0
@export var max_attack_delay = 0.0
@export var halt_duration = 0.5
@export var between_shots = BetweenShotsBehavior.STAY
@export var move_speed = 30.0

var fire_timer = 0.0
var halt_timer = 0.0

func _ready() -> void:
	Utils.configure_templates(self)

func _physics_process(delta: float) -> void:
	fire_timer -= delta


func enter() -> void:
	if max_attack_delay < min_attack_delay:
		max_attack_delay = min_attack_delay
	if ai.target == null:
		ai.target = Global.player
	if between_shots == BetweenShotsBehavior.STAY:
		owner.get_meta("move").enabled = false
		owner.velocity = Vector2.ZERO
		owner.get_meta("move").move()
	elif between_shots == BetweenShotsBehavior.MOVE_CLOSER:
		owner.get_meta("move").speed = move_speed
		owner.get_meta("move").enabled = true


func physics_update(delta: float) -> void:
	if halt_timer > 0:
		owner.get_meta("move").speed = 0
		halt_timer -= delta
		if halt_timer <= 0:
			owner.get_meta("move").speed = move_speed
	else:
		owner.get_meta("move").navigation_agent.target_position = ai.target.global_position
	if fire_timer <= 0:
		fire()


func fire() -> void:
	Utils.spawn(
		self,
		global_position,
		global_position.angle_to_point(ai.target.global_position),
		null)
	fire_timer = randf_range(min_attack_delay, max_attack_delay)
	halt_timer = halt_duration
