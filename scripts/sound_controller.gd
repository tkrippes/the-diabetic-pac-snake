class_name SoundController
extends Node

@onready var pause_sound: AudioStreamPlayer = $PauseSound
@onready var unpause_sound: AudioStreamPlayer = $UnpauseSound


func play_pause_sound() -> void:
    pause_sound.play()


func play_unpause_sound() -> void:
    unpause_sound.play()