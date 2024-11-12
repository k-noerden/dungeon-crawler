class_name TouchComponent
extends Area2D

@export var sound: AN.Sound = AN.Sound.NO_SOUND

func _enter_tree() -> void:
	owner.set_meta("TouchComponent", self)
func _exit_tree() -> void:
	if owner != null: # owner will be freed before children
		owner.remove_meta("TouchComponent")

signal touched(area: Area2D)

func _ready() -> void:
	assert(collision_layer == 1)
	assert(collision_mask == 1)
	collision_layer = 0
	collision_mask = 0
	set_collision_mask_value(Global.LAYER_TOUCH, true)
	area_entered.connect(touch)

func touch(area: Area2D) -> void:
	var who = area.owner
	if owner.has_method("touch"):
		owner.touch(who)
	touched.emit(who)
	Audio.play(sound, owner.global_position)
