extends Node

var game: Node2D
var ephemeral: Node2D
var player: Node2D
var current_item: Node2D

var points: int = 0
# signal points_changed(value: int, change: int)
signal points_changed
