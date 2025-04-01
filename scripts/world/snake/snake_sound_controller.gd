class_name SnakeSoundController
extends Node
## The SnakeSoundController is responsible for managing the sounds when the snake interacts with the world.
##
## The snake emits a different sound when it eats a fruit, runs into a wall, runs into itself or eats a fruit.
## Additionally, the snake hisses when the game starts.

@onready var fruit_eating_sound: AudioStreamPlayer = $FruitEatingSound
@onready var snake_squished_sound: AudioStreamPlayer = $SnakeSquishedSound
@onready var snake_suffocating_sound: AudioStreamPlayer = $SnakeSuffocatingSound
@onready var snake_sucked_in_sound: AudioStreamPlayer = $SnakeSuckedInSound
@onready var snake_hissing_sound: AudioStreamPlayer = $SnakeHissingSound


## Plays the sound when the snake eats a fruit.
func play_fruit_eating_sound() -> void:
	fruit_eating_sound.play()


# Plays the sound when the snake runs into a wall.
func play_death_by_wall_sound() -> void:
	snake_squished_sound.play()


# Plays the sound when the snake eats a sweet.
func play_death_by_sweets_sound() -> void:
	snake_suffocating_sound.play()


# Plays the sound when the snake runs into itself.
func play_death_by_self_digestion_sound() -> void:
	snake_sucked_in_sound.play()


# Plays the sound when the game starts.
func play_start_sound() -> void:
	snake_hissing_sound.play()