class_name GameoverComponent
extends Node2D

func _enter_tree() -> void:
	owner.set_meta("death", self)

func _exit_tree() -> void:
	if owner:
		owner.remove_meta("death")


func death() -> void:
	Global.game.gameover()
