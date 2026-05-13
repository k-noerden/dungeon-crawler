class_name DamageStunComponent
extends Node2D

func _enter_tree() -> void:
	owner.set_meta("damage", self)

func _exit_tree() -> void:
	if owner:
		owner.remove_meta("damage")


func damage(body: Node2D) -> void:
	var damage = randf_range(owner.min_damage, owner.max_damage)
	var health = body.get_meta("health", false)
	if health:
		health.damage(damage)

	var ai = body.get_meta("ai")
	if ai:
		var move = body.get_meta("move", false)
		ai.process_mode = PROCESS_MODE_DISABLED
		move.process_mode = PROCESS_MODE_DISABLED
		var _anim = body.get_node("AnimatedSprite2D")
		if _anim:
			var animation = owner.get("animation")
			if animation and _anim.sprite_frames.has_animation(animation):
				_anim.play(animation)
			else:
				_anim.pause()
		var done = func ():
			if ai: # still alive
				ai.process_mode = PROCESS_MODE_INHERIT
				move.process_mode = PROCESS_MODE_INHERIT
				if _anim:
					_anim.play()
		get_tree().create_timer(owner.duration).timeout.connect(done)
