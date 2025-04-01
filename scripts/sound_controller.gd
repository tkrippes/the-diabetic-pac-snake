class_name SoundController
extends Node
## SoundController manages sounds related to the game's current state that are not directly influenced by the game elements.

@onready var background_music: AudioStreamPlayer = $BackgroundMusic
@onready var pause_sound: AudioStreamPlayer = $PauseSound
@onready var unpause_sound: AudioStreamPlayer = $UnpauseSound
@onready var game_won_sound: AudioStreamPlayer = $GameWonSound

var _background_music_position: float = 0.0


## Plays the background music from the beginning.
func start_background_music() -> void:
    _background_music_position = 0.0
    play_background_music()


## Plays the background music from the last played position.
func play_background_music() -> void:
    background_music.play(_background_music_position)


## Stops the background music and saves the last played position.
func stop_background_music() -> void:
    _background_music_position = background_music.get_playback_position()
    background_music.stop()


## Plays the paus sound effect. 
func play_pause_sound() -> void:
    pause_sound.play()


## Plays the unpause sound effect.
func play_unpause_sound() -> void:
    unpause_sound.play()


## Plays the game won sound effect.
func play_game_won_sound() -> void:
    game_won_sound.play()