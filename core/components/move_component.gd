@icon("res://assets/icons/configurable.svg")
class_name MoveComponent
extends Node2D

@export var speed = 100.0
@export var move_animation: String
@export var idle_animation: String

var enabled = true
var navigation_agent: NavigationAgent2D
var animation: AnimatedSprite2D

func _enter_tree() -> void:
	owner.set_meta("move", self)

func _exit_tree() -> void:
	if owner: # owner will be freed before children
		owner.remove_meta("move")


func _ready() -> void:
	navigation_agent = null
	for child in get_children():
		if child is NavigationAgent2D:
			navigation_agent = child
			break
	if navigation_agent == null:
		navigation_agent = NavigationAgent2D.new()
		add_child(navigation_agent)
		var shape = owner.get_node("CollisionShape2D").shape
		assert(shape is CircleShape2D)
		navigation_agent.radius = shape.radius
		navigation_agent.path_postprocessing = NavigationPathQueryParameters2D.PathPostProcessing.PATH_POSTPROCESSING_EDGECENTERED
		navigation_agent.avoidance_enabled = true
	navigation_agent.velocity_computed.connect(_on_velocity_computed)
	animation = owner.get_node("AnimatedSprite2D")
	assert(animation)
	assert(animation.sprite_frames.has_animation(move_animation), "Missing move animation in " + str(owner))
	assert(animation.sprite_frames.has_animation(idle_animation), "Missing idle animation in " + str(owner))

func _physics_process(delta: float) -> void:
	if !enabled:
		return
	if navigation_agent.is_navigation_finished():
		return
	var direction = owner.global_position.direction_to(navigation_agent.get_next_path_position())
	var new_velocity = direction * speed
	#owner.velocity = new_velocity
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector2) -> void:
	if !enabled:
		return
	owner.velocity = safe_velocity
	move()

func move() -> bool:
	#owner.velocity = new_velocity
	var collided = owner.move_and_slide()
	if owner.velocity.length() > 0:
		animation.play(move_animation)
		animation.flip_h = owner.velocity.x < 0
	else:
		animation.play(idle_animation)
	return collided


# func _unhandled_input(event: InputEvent) -> void:
# 	if event.is_action_pressed("debug"):
# 		print("debug Mouse: ", get_global_mouse_position())
# 		# navigation_agent.target_position = get_global_mouse_position()
