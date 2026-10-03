extends Node2D


@export var initial_level = "starting_level"
@export var coordinate: Vector2 = Vector2.ZERO

func _ready() -> void:
	Global.game = self
	Global.ephemeral = $Ephemeral
	Global.player = $Player
	LevelLoader.change_to(initial_level, coordinate)
	LevelLoader.initialize()


func gameover() -> void:
	get_tree().paused = true
	%Ui.hide()
	%Gameover.show()
	%Gameover.get_node("Points").text = "Points: " + str(Global.points)
