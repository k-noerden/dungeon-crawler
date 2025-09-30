@icon("res://assets/icons/configurable.svg")
class_name AiComponent
extends Node2D

@export var initial_behavior: Behavior = null
@export_flags_2d_physics var vision_mask: int

var behaviors: Dictionary = {}
var current_behavior

# State:
var duration: float
# --
var target: Node2D: # Set by behaviors / conditions
	set(value):
		target = value
		last_seen_target_position = global_position # Bit of a hack, but causes last_seen_target_position to be very close causing condition to change
		has_last_seen_target_position = false
var target_distance: float
var is_target_visible: bool
var last_seen_target_position: Vector2 # Note: null can't be assigned to variant types, https://docs.godotengine.org/en/stable/engine_details/architecture/variant_class.html
var has_last_seen_target_position: bool = false # So a bool is used to track if it is valid instead of using null


func _enter_tree() -> void:
	owner.set_meta("ai", self)
	reset()
func _exit_tree() -> void:
	if owner:
		owner.remove_meta("ai")

func _ready():
	for child in get_children():
		if child is Behavior:
			if initial_behavior == null:
				initial_behavior = child
			child.ai = self
			assert(child.name, "Behaviour must have name")
			assert(not behaviors.has(child.name), "Behavior names must be unique")
			behaviors[child.name] = child
			child.transitioned.connect(on_child_transitioned)
	for behavior in behaviors.values():
		for child in behavior.get_children():
			if child.has_method("condition"):
				assert(behaviors.has(child.next_behavior), "Condition next behavior must be an existing behavior" + str(behavior) + " " + str(child))

func reset() -> void:
	await get_tree().create_timer(1.0).timeout
	current_behavior = null
	on_child_transitioned(null, initial_behavior.name)

func _physics_process(delta: float) -> void:
	if current_behavior:
		if not target:
			target = Global.player
		target_distance = global_position.distance_to(target.global_position)
		var space_state = get_world_2d().direct_space_state
		var ray_query = PhysicsRayQueryParameters2D.create(global_position, target.global_position, vision_mask)
		var collision = space_state.intersect_ray(ray_query)
		if !collision: # Can see target
			is_target_visible = true
			last_seen_target_position = target.global_position
			has_last_seen_target_position = true
		else:
			is_target_visible = false
		duration += delta
		for child in current_behavior.get_children():
			if child.has_method("condition"):
				if child.condition(self):
					on_child_transitioned(current_behavior, child.next_behavior)
					return # Return so all conditions are executed for new behavior
		current_behavior.physics_update(delta)

func on_child_transitioned(from_behavior, new_behavior_name: String) -> void:
	if from_behavior != current_behavior:
		return # ignore
	print(new_behavior_name)
	var new_behavior = behaviors.get(new_behavior_name)
	assert(new_behavior, "Unknown behavior " + new_behavior_name + ";")
	if current_behavior:
		current_behavior.exit()
	current_behavior = new_behavior
	duration = 0.0
	current_behavior.enter()
	for child in current_behavior.get_children():
		if child.has_method("prepare"):
			child.prepare(self)
