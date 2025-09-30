@icon("res://assets/icons/configurable.svg")
class_name WanderBehavior
extends Behavior

@export var min_wander_duration = 2.0
@export var max_wander_duration = 5.0
@export var min_still_duration = 0.0
@export var max_still_duration = 1.0
@export var speed = 30.0;

var direction: Vector2
var wander_time = 0.0
var still_time = 0.0

func _ready() -> void:
	assert(owner.has_meta("move"))

func setup() -> void:
	var angle = randf_range(0, PI * 2.0)
	direction = Vector2.UP.rotated(angle)
	wander_time = randf_range(min_wander_duration, max_wander_duration)
	still_time = randf_range(min_still_duration, max_still_duration)

func enter() -> void:
	owner.get_meta("move").enabled = false
	owner.get_meta("move").speed = speed
	setup()
	# direction = owner.velocity.normalized()

func physics_update(delta: float) -> void:
	if wander_time > 0:
		wander_time -= delta
		owner.velocity = direction * speed
		if owner.get_meta("move").move():
			# Collided with someting
			setup()
			return
		return
	if still_time > 0:
		still_time -= delta
		owner.velocity = Vector2.ZERO
		owner.get_meta("move").move()
		return
	setup()
