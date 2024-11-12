class_name Damage
extends RefCounted

var plain = 0.0
var fire = 0.0

func _init(plain := 0.0, fire := 0.0) -> void:
	self.plain = plain
	self.fire = fire
