class_name Weapon
extends Node2D

var state = Global.WeaponState.GROUNDED
var target = Vector2.ZERO

var attack_mask: int

@export var attack_class: PackedScene
@export_flags_2d_physics var weapon_attack_mask: int = 1
@export var sound: AN.Sound = AN.Sound.NO_SOUND
@export var animation_equip: String = "";
@export var animation_hold: String = "";
@export var animation_fire: String = "";

@onready var pivot = $Pivot
@onready var grounded = $Grounded
var firepoint: Node2D
var icon: Texture2D

func _ready() -> void:
	if has_node("Pivot/FirePoint"):
		firepoint = $Pivot/FirePoint
	else:
		firepoint = $Pivot
	assert(animation_equip == "" or %AnimatedSprite2D.sprite_frames.has_animation(animation_equip), "Unknown Animation Equip")
	assert(animation_hold == "" or %AnimatedSprite2D.sprite_frames.has_animation(animation_hold), "Unknown Animation Hold")
	assert(animation_fire == "" or %AnimatedSprite2D.sprite_frames.has_animation(animation_fire), "Unknown Animation Fire")
	assert(animation_hold != "")
	%AnimatedSprite2D.animation_finished.connect(_on_animated_sprite_2d_animation_finished)
	icon = %AnimatedSprite2D.sprite_frames.get_frame_texture(animation_hold, 0)

func _on_animated_sprite_2d_animation_finished() -> void:
	if animation_hold:
		%AnimatedSprite2D.play(animation_hold)

func _physics_process(delta: float) -> void:
	if state == Global.WeaponState.HELD:
		pivot.look_at(target)
		if pivot.global_rotation < -PI / 2.0 or pivot.global_rotation > PI / 2.0:
			%AnimatedSprite2D.flip_v = true
		else:
			%AnimatedSprite2D.flip_v = false

func fire() -> void:
	var damage = get_meta("DamageComponent").make_damage()
	var attack = attack_class.instantiate()
	attack.damage = damage
	attack.collision_mask = weapon_attack_mask | attack_mask
	attack.global_position = firepoint.global_position
	attack.global_rotation = firepoint.global_rotation
	Global.ephemeral.add_child(attack)
	Audio.play(sound, global_position)
	if animation_fire:
		%AnimatedSprite2D.play(animation_fire)

func interact(who: Node2D) -> bool:
	who.get_meta("inventory").pickup_weapon(self)
	return true


func pickup(holder: Node2D) -> void:
	state = Global.WeaponState.HELD
	position = Vector2.ZERO
	get_node("Area2D/CollisionShape2D").set_deferred("disabled", true)
	attack_mask = holder.attack_mask

func drop(holder: Node2D) -> void:
	if animation_hold:
		%AnimatedSprite2D.play(animation_hold)
		%AnimatedSprite2D.stop()
	state = Global.WeaponState.GROUNDED
	get_node("Area2D/CollisionShape2D").set_deferred("disabled", false)
	pivot.rotation = 0.0;
	%AnimatedSprite2D.flip_v = false
	global_position = holder.global_position + (global_position - %AnimatedSprite2D.global_position) + Vector2(0, 8)


func equip() -> void:
	if animation_equip:
		%AnimatedSprite2D.play(animation_equip)

func unequip() -> void:
	pass

# damage_layer: Use attack_mask
# trigger: Use get_meta
