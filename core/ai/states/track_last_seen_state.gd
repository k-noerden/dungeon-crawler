class_name TrackLastSeenState
extends State

@export var target: Node2D
@export var speed = 100.0
@export var min_idle_duration = 3.0
@export var max_idle_duration = 6.0
@export var lost_track_state: String

func enter(detector: Node) -> void:
	if state_machine.target == null:
		state_machine.target = Global.player
	owner.get_meta("MoveComponent").speed = speed
	owner.get_meta("MoveComponent").enabled = true

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug"):
		print("Mouse: ", get_global_mouse_position())

func physics_update(delta: float) -> void:
	owner.get_meta("MoveComponent").target_position = state_machine.last_seen_target_position
	if global_position.distance_to(state_machine.last_seen_target_position) < 10:
		change_state(lost_track_state)
