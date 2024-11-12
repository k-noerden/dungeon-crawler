extends Node2D

@export var map: String
@export var coordinate: Vector2
#@export var mapp: PackedScene

func _ready() -> void:
	%AnimatedSprite2D.play("pulse")
	#%AnimatedSprite2D.play("inactive")

func interact(who: Node2D) -> bool:
	LevelLoader.change_to(map, coordinate)
	return true
