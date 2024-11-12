extends Node2D

func _ready() -> void:
	Global.game = self
	Global.ephemeral = %Ephemeral
	Global.player = $Player
	LevelLoader.change_to("starting_level", Vector2.ZERO)
	#LevelLoader.change_to("third_level", Vector2.ZERO)
	LevelLoader.initialize()

func game_over():
	%Ui.hide()
	get_tree().paused = true
	%GameOver.show()
	%GameOver.get_node("Points").text = "Points: " + str(Global.points)
