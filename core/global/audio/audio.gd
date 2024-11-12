extends Node2D
# Inspired by https://github.com/Aarimous/AudioManager


@export var sound_effects: Array[SoundEffect]
var sound_effect_dict = {}

func _ready() -> void:
	for sound_effect in sound_effects:
		assert(!sound_effect_dict.has(sound_effect.name), "Duplicate sound effect " + str(sound_effect.name))
		sound_effect_dict[sound_effect.name] = sound_effect
	print(sound_effect_dict)
	for key in AN.Sound:
		var name = AN.Sound[key]
		if name == AN.Sound.NO_SOUND:
			continue
		if !sound_effect_dict.has(name):
			pass
			assert(false, "Missing sound for: " + str(key))

func play(name: AN.Sound, position: Vector2) -> void:
	if name == AN.Sound.NO_SOUND:
		return
	if !sound_effect_dict.has(name):
		print(sound_effect_dict)
		assert(sound_effect_dict.has(name), "Uknown sound: " + str(name))
	var sound_effect: SoundEffect = sound_effect_dict[name]
	if !sound_effect.can_play():
		return
	sound_effect.change_count(1)
	var audio = AudioStreamPlayer2D.new()
	add_child(audio)
	audio.position = position
	audio.stream = sound_effect.sound
	audio.volume_db = sound_effect.volume
	audio.pitch_scale = sound_effect.pitch_scale
	audio.pitch_scale += randf_range(-sound_effect.pitch_randomness, sound_effect.pitch_randomness)
	audio.finished.connect(sound_effect.on_audio_finished)
	audio.finished.connect(audio.queue_free)
	audio.play()
