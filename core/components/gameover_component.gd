class_name GameoverComponent
extends Node2D

func _ready() -> void:
	set_meta("is_action", self)

func action(who: Node2D) -> void:
	Global.game.gameover()
