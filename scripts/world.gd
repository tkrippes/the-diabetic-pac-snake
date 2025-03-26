class_name World
extends Node2D

signal snake_ate_fruit
signal snake_died

@export var arena_settings: ArenaSettings

@onready var snake: Snake = $Snake
@onready var fruits_controller: SpawnController = $FruitsController
@onready var sweets_controller: SpawnController = $SweetsController


func _process(_delta: float) -> void:
	var occupied_positions: Array[Vector2] = snake.get_occupied_positions()
	occupied_positions.append_array(fruits_controller.get_occupied_positions())
	occupied_positions.append_array(sweets_controller.get_occupied_positions())
	
	arena_settings.set_occupied_grid_position(occupied_positions)


func _on_snake_ate_fruit() -> void:
	fruits_controller.reset_timer()
	snake_ate_fruit.emit()


func _on_snake_died() -> void:
	fruits_controller.stop()
	sweets_controller.stop()
	snake_died.emit()


func start() -> void:
	snake.start()
	fruits_controller.start()
	sweets_controller.start()
	
	
func reset() -> void:
	snake.reset()
