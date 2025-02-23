class_name MoveComponent
extends NavigationAgent2D

func _enter_tree() -> void:
	owner.set_meta("MoveComponent", self)
func _exit_tree() -> void:
	if owner != null: # owner will be freed before children
		owner.remove_meta("MoveComponent")

@export var speed = 100.0
@export var animate = true
@export var animation: AnimatedSprite2D = null
@export var auto = true;
@export var sound: AN.Sound = AN.Sound.NO_SOUND
@export var sound_interval = 0.1
@export var sound_speed_multiplier: float = 1.0
var sound_timer = 0.0
var enabled = true

func _ready() -> void:
	velocity_computed.connect(_on_velocity_computed)
	if auto:
		var shape = owner.get_node("CollisionShape2D").shape
		assert(shape is CircleShape2D)
		radius = shape.radius
		path_postprocessing = NavigationPathQueryParameters2D.PathPostProcessing.PATH_POSTPROCESSING_EDGECENTERED
		avoidance_enabled = true
	if animate and animation == null:
		animation = owner.get_node("AnimatedSprite2D")
		assert(animation != null)
	assert(animate == true if animation != null else true)

func _physics_process(delta: float) -> void:
	sound_timer -= delta
	if sound_timer <= 0:
		#var current_speed = owner.velocity.length()
		var current_speed = speed
		# print(current_speed)
		if current_speed < 1:
			sound_timer += delta
		else:
			Audio.play(sound, owner.global_position)
			#sound_timer = (1.0 / current_speed) * sound_speed_multiplier
			sound_timer = sound_interval
			#print(sound_timer)
	if !enabled:
		return
	if is_navigation_finished():
		return
	var direction = owner.global_position.direction_to(get_next_path_position())
	var new_velocity = direction * speed
	#owner.velocity = new_velocity
	if avoidance_enabled:
		set_velocity(new_velocity)
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
	if animate:
		if owner.velocity.length() > 0:
			animation.play("run")
			animation.flip_h = owner.velocity.x < 0
		else:
			animation.play("idle")
	return collided
