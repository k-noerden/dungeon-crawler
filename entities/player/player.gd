extends CharacterBody2D

var current_weapon: Node2D = null
var attack_mask = Global.MASK_ENEMIES

func interact_action() -> void:
	var areas = %InteractionArea.get_overlapping_areas()
	for area in areas:
		if area.has_method("interact"):
			if area.interact(self):
				break
			continue
		var other = area.owner
		if other.interact(self):
			break

func die() -> void:
	Global.game.game_over()
