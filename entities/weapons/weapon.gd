class_name Weapon
extends Node2D

var state = Global.WeaponState.GROUNDED
var target = Vector2.ZERO

var attack_mask: int

@export var attack_class: PackedScene
@export_flags_2d_physics var weapon_attack_mask: int = 1
@export var sound: AN.Sound = AN.Sound.NO_SOUND

@onready var held = $Held
@onready var grounded = $Grounded
var firepoint: Node2D

func _ready() -> void:
	if has_node("Held/FirePoint"):
		firepoint = $Held/FirePoint
	else:
		firepoint = held

func _physics_process(delta: float) -> void:
	if state == Global.WeaponState.HELD:
		held.look_at(target)
		if held.global_rotation < -PI / 2.0 or held.global_rotation > PI / 2.0:
			%Sprite2D.flip_v = true
		else:
			%Sprite2D.flip_v = false

func fire() -> void:
	var damage = get_meta("DamageComponent").make_damage()
	var attack = attack_class.instantiate()
	attack.damage = damage
	attack.collision_mask = weapon_attack_mask | attack_mask
	attack.global_position = firepoint.global_position
	attack.global_rotation = firepoint.global_rotation
	Global.ephemeral.add_child(attack)
	Audio.play(sound, global_position)

func interact(who: Node2D) -> bool:
	who.get_meta("inventory").pickup_weapon(self)
	return true


func pickup(holder: Node2D) -> void:
	state = Global.WeaponState.HELD
	position = Vector2.ZERO
	grounded.get_node("Area2D/CollisionShape2D").set_deferred("disabled", true)
	grounded.hide()
	held.show()
	attack_mask = holder.attack_mask

func drop(holder: Node2D) -> void:
	state = Global.WeaponState.GROUNDED
	grounded.get_node("Area2D/CollisionShape2D").set_deferred("disabled", false)
	held.hide()
	grounded.show()

func equip() -> void:
	pass

func unequip() -> void:
	pass

# damage_layer: Use attack_mask
# trigger: Use get_meta
