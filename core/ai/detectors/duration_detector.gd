class_name DurationDetector
extends Node2D

@export var next_state: String
@export var duration = 1.0
@export var sound: AN.Sound = AN.Sound.NO_SOUND

func detect_state_change(state_machine: StateMachineComponent) -> bool:
	if state_machine.duration > duration:
		Audio.play(sound, owner.global_position)
		return true
	return false
