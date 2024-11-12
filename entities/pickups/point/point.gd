extends Node2D

@export var points = 1

func _ready() -> void:
	%AnimatedSprite2D.play("bounce")

func touch(who: Node2D):
	Global.points += points
	SignalBus.points_changed.emit(Global.points, points)
	Audio.play(AN.Sound.STEP, global_position)
	queue_free()
