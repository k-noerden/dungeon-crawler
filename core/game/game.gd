extends Node2D


func _ready() -> void:
	Global.game = self
	Global.ephemeral = $Ephemeral
	Global.player = $Player
	LevelLoader.change_to("starting_level", Vector2.ZERO)
	LevelLoader.initialize()


func gameover() -> void:
	get_tree().paused = true
	%Ui.hide()
	%Gameover.show()
	%Gameover.get_node("Points").text = "Points: " + str(Global.points)
