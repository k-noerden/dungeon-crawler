class_name StateMachineComponent
extends Node2D

func _enter_tree() -> void:
	owner.set_meta("StateMachineComponent", self)
	reset()

func _exit_tree() -> void:
	if owner != null: # owner will be freed before children
		owner.remove_meta("StateMachineComponent")

@export var initial_state: State = null

var target: Node2D: # Set by state / detectors
	set(value):
		target = value
		last_seen_target_position = global_position
		has_seen_target = false
var is_target_visible: bool # Calculated
var has_seen_target: bool
var last_seen_target_position: Vector2 # Calculated
var target_distance: float # Calculated

var duration: float

#var ray: RayCast2D
#@export_flags_2d_physics var ray_mask: int
@export_flags_2d_physics var vision_mask: int

var current_state: State
var states: Dictionary = {}
var is_ready = false

func _ready() -> void:
	#if has_node("RayCast2D"):
		#ray = $RayCast2D
	#else:
		#ray = RayCast2D.new()
		#add_child(ray)

	for child in get_children():
		if child is State:
			if initial_state == null:
				initial_state = child
			child.state_machine = self
			states[child.name] = child
			child.transitioned.connect(on_child_transitioned)

func reset() -> void:
	is_ready = false
	await get_tree().create_timer(1.0).timeout
	is_ready = true
	current_state = null
	on_child_transitioned(null, initial_state.name, null)

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		if target:
			target_distance = global_position.distance_to(target.global_position)
			var space_state = get_world_2d().direct_space_state
			var ray_query = PhysicsRayQueryParameters2D.create(global_position, target.global_position, vision_mask)
			var collision = space_state.intersect_ray(ray_query)
			if !collision: # Can see target
				is_target_visible = true
				last_seen_target_position = target.global_position
				has_seen_target = true
			else:
				is_target_visible = false
		duration += delta
		for child in current_state.get_children():
			if !child.has_method("detect_state_change"):
				continue
			if child.detect_state_change(self):
				on_child_transitioned(current_state, child.next_state, child)
				return # Return so all detect_state_changes are executed for new state
		current_state.physics_update(delta)

func on_child_transitioned(from_state: State, new_state_name: String, detector: Node) -> void:
	if from_state != current_state:
		return # ignore
	var new_state = states.get(new_state_name)
	if !new_state:
		return
	if current_state:
		current_state.exit()
	current_state = new_state
	duration = 0.0
	print("Changing to state ", new_state_name)
	new_state.enter(detector)
	for child in current_state.get_children():
		if !child.has_method("prepare"):
			continue
		child.prepare(self)
