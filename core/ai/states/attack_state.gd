class_name AttackState
extends State

enum BetweenShotsBehaviour {STAY, MOVE_CLOSER}
@export var attack_class: PackedScene
@export var min_attack_delay = 4.0
@export var max_attack_delay = 0.0
@export var min_distance = 0.0
@export var max_distance = 50

@export var move_speed = 30
@export var halt_duration = 0.5
@export var between_shots = BetweenShotsBehaviour.STAY
# @export var too_close_state: String
# @export var too_far_state: String
# @export var lost_sight_state: String

var damage_component: DamageComponent

var fire_timer = 0.0
var halt_timer = 0.0
@export_flags_2d_physics var attack_mask: int = 1

func _ready() -> void:
	damage_component = $DamageComponent
	assert(attack_class != null)

func _physics_process(delta: float) -> void:
	fire_timer -= delta

func enter(detector: Node) -> void:
	if max_attack_delay < min_attack_delay:
		max_attack_delay = min_attack_delay
	if state_machine.target == null:
		state_machine.target = Global.player
	if between_shots == BetweenShotsBehaviour.STAY:
		owner.get_meta("MoveComponent").enabled = false
		owner.velocity = Vector2.ZERO
		owner.get_meta("MoveComponent").move()
	elif between_shots == BetweenShotsBehaviour.MOVE_CLOSER:
		owner.get_meta("MoveComponent").speed = move_speed
		owner.get_meta("MoveComponent").enabled = true


func physics_update(delta: float) -> void:
	if halt_timer > 0:
		owner.get_meta("MoveComponent").speed = 0
		halt_timer -= delta
		if halt_timer <= 0:
			owner.get_meta("MoveComponent").speed = move_speed
	else:
		owner.get_meta("MoveComponent").target_position = state_machine.target.global_position

	if fire_timer <= 0:
		fire()


func fire() -> void:
	var damage = damage_component.make_damage()
	var attack = attack_class.instantiate()
	attack.damage = damage
	attack.collision_mask = attack_mask
	attack.global_position = global_position
	attack.global_rotation = global_position.angle_to_point(state_machine.target.global_position)
	Global.ephemeral.add_child(attack)
	fire_timer = randf_range(min_attack_delay, max_attack_delay)
	halt_timer = halt_duration
