class_name SoundEffect
extends Resource


@export var name: AN.Sound
@export var sound: AudioStream
@export_range(0, 10) var limit: int = 5
@export_range(-40, 20) var volume = 0
@export_range(0.0, 4.0, 0.01) var pitch_scale = 1.0
@export_range(0.0, 1.0, 0.01) var pitch_randomness = 0.0

var currently_playing_count = 0

func change_count(amount: int):
	currently_playing_count += amount
	if currently_playing_count < 0:
		currently_playing_count = 0

func can_play() -> bool:
	return currently_playing_count < limit

func on_audio_finished():
	change_count(-1)
