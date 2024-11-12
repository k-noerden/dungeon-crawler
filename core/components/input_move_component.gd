class_name InputMoveComponent
extends Component

@export var speed = 200
@export var animation: AnimatedSprite2D;

@export var acceleration = 20

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	owner.velocity = direction * speed
	owner.move_and_slide()

	#if direction.length() > 0:
		#owner.velocity += direction * acceleration
	#owner.move_and_slide()
	#owner.velocity *= 0.85
	#if owner.velocity.length() < 0.3:
		#owner.velocity = Vector2.ZERO

	if owner.velocity.length() > 0:
		animation.play("run")
		animation.flip_h = owner.velocity.x < 0
	else:
		animation.play("idle")
