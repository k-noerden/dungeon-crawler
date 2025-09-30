@icon("res://assets/icons/configurable.svg")
class_name TriggerSemiAutomaticComponent
extends Node2D

@export var fire_rate = 1.0;

@export var equip_animation: String
@export var idle_animation: String
@export var fire_animation: String

var enabled = false
var timer = 0.0
var firepoint: Node2D
var animation: AnimatedSprite2D

func _ready() -> void:
	Utils.configure_templates(self)

func _enter_tree() -> void:
	owner.set_meta("trigger", self)
	assert(get_child(0) != null, "No attack attached to trigger in " + str(owner))
	firepoint = owner.find_child("FirePoint")
	assert(firepoint)

	for child in owner.get_children():
		if child is AnimatedSprite2D:
			animation = child
			break
	assert(equip_animation == "" or animation.sprite_frames.has_animation(equip_animation), "Missing equip animation in " + str(owner))
	assert(animation.sprite_frames.has_animation(idle_animation), "Missing idle animation in " + str(owner))
	assert(animation.sprite_frames.has_animation(fire_animation), "Missing fire animation in " + str(owner))


func _exit_tree() -> void:
	if owner:
		owner.remove_meta("trigger")

func enable() -> void:
	enabled = true
	animation.animation_finished.connect(_on_animated_sprite_2d_animation_finished)
	if equip_animation:
		animation.play(equip_animation)

func disable() -> void:
	enabled = false

func _on_animated_sprite_2d_animation_finished() -> void:
	animation.play(idle_animation)

func _physics_process(delta: float) -> void:
	if not enabled:
		return
	timer += delta
	if Input.is_action_just_pressed("fire"):
		if timer > fire_rate:
			timer = 0;
			fire()


func fire() -> void:
	Utils.spawn(
		self,
		firepoint.global_position,
		firepoint.global_rotation,
		null)
	animation.play(fire_animation)
