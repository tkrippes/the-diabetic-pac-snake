class_name World
extends Node2D

## The signal emitted when the snake eats a fruit.
signal snake_ate_fruit
## The signal emitted when the snake dies.
signal snake_died

## The settings of the arena containing sizes as well as currently occupied positions.
@export var arena_settings: ArenaSettings

@onready var snake_controller: SnakeController = $SnakeController
@onready var fruits_controller: SpawnController = $FruitsController
@onready var sweets_controller: SpawnController = $SweetsController


func _process(_delta: float) -> void:
	var occupied_positions: Array[Vector2] = snake_controller.get_occupied_positions()
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


## Starts the current world.
## Starts the snake and the spawners.
func start() -> void:
	snake_controller.start()
	fruits_controller.start()
	sweets_controller.start()


## Resets the current world.
## Resets the snake to its original size and position.
func reset() -> void:
	snake_controller.reset()
