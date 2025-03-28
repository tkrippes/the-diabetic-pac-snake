class_name SnakeSoundController
extends Node

@onready var fruit_eating_sound: AudioStreamPlayer = $FruitEatingSound
@onready var snake_squished_sound: AudioStreamPlayer = $SnakeSquishedSound
@onready var snake_suffocating_sound: AudioStreamPlayer = $SnakeSuffocatingSound
@onready var snake_sucked_in_sound: AudioStreamPlayer = $SnakeSuckedInSound
@onready var snake_hissing_sound: AudioStreamPlayer = $SnakeHissingSound


func play_fruit_eating_sound() -> void:
	fruit_eating_sound.play()


func play_death_by_wall_sound() -> void:
	snake_squished_sound.play()


func play_death_by_sweets_sound() -> void:
	snake_suffocating_sound.play()


func play_death_by_self_digestion_sound() -> void:
	snake_sucked_in_sound.play()


func play_start_sound() -> void:
	snake_hissing_sound.play()