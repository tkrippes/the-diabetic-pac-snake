class_name SoundController
extends Node

@onready var background_music: AudioStreamPlayer = $BackgroundMusic
@onready var pause_sound: AudioStreamPlayer = $PauseSound
@onready var unpause_sound: AudioStreamPlayer = $UnpauseSound

var _background_music_position: float = 0.0


func start_background_music() -> void:
    _background_music_position = 0.0
    play_background_music()


func play_background_music() -> void:
    background_music.play(_background_music_position)


func stop_background_music() -> void:
    _background_music_position = background_music.get_playback_position()
    background_music.stop()


func play_pause_sound() -> void:
    pause_sound.play()


func play_unpause_sound() -> void:
    unpause_sound.play()