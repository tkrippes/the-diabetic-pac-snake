class_name World
extends Node2D

signal snake_ate_fruit
signal snake_died

@export var fruit_scene: PackedScene
@export var sweet_scene: PackedScene

@onready var snake: Snake = $Snake

@onready var fruit_controller: FruitController = $FruitController

@onready var sweets: Array[Node2D] = [$Candy1, $Candy2]
@onready var initial_sweet_positions: Array[Vector2] = [sweets[0].position, sweets[1].position]


func _on_snake_ate_fruit() -> void:
	fruit_controller.reset_timer()
	snake_ate_fruit.emit()


func _on_snake_died() -> void:
	get_tree().call_group("sweets", "queue_free")
	snake_died.emit()
	fruit_controller.stop()


func start() -> void:
	snake.start()
	fruit_controller.start()
	
	
func reset() -> void:
	snake.reset()
	reset_sweets()

		
func reset_sweets() -> void:
	sweets.clear()

	for i in range(initial_sweet_positions.size()):
		var sweet: Node2D = sweet_scene.instantiate()
		sweet.position = initial_sweet_positions[i]

		sweets.append(sweet)
		add_child(sweet)
