class_name DieComponent
extends Component

const Point = preload("res://entities/pickups/point/point.tscn")

@export var points = 1
@export var should_free = true

func die():
	if points > 0:
		var point = Point.instantiate()
		point.points = points
		point.global_position = owner.global_position
		LevelLoader.current_level.add_child(point)
	if should_free:
		owner.queue_free()
