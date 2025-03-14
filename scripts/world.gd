class_name World
extends Node2D

signal snake_died

@onready var snake: Snake = $Snake


func _on_snake_died() -> void:
	snake_died.emit()
	

func start_snake() -> void:
	snake.start()
