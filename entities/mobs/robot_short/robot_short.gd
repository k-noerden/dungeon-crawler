extends CharacterBody2D

var damage_layer = Global.LAYER_PLAYER


func _ready() -> void:
	pass
	#navigation_agent.velocity_computed.connect(_on_velocity_computed)
	#navigation_agent.path_desired_distance = 10.0
	#navigation_agent.target_desired_distance = 10.0
	#navigation_agent.debug_enabled = true

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		get_meta("MoveComponent").target_position = get_global_mouse_position()

#func _physics_process(delta: float) -> void:
	#if navigation_agent.is_navigation_finished():
		#return
	#var current = global_position
	#var next = navigation_agent.get_next_path_position()
	#velocity = current.direction_to(next) * 100
	#if navigation_agent.avoidance_enabled:
		#navigation_agent.set_velocity(velocity)
	#else:
		#_on_velocity_computed(velocity)
	##move_and_slide()
#
#func _on_velocity_computed(safe_velocity: Vector2) -> void:
	#velocity = safe_velocity
	#move_and_slide()
