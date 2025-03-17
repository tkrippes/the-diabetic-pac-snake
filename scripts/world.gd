class_name World
extends Node2D

signal snake_ate_fruit
signal snake_died

@export var fruit_scene: PackedScene

@onready var snake: Snake = $Snake
@onready var fruits: Array[Node2D] = [$Banana1, $Banana2]
@onready var initial_fruit_positions: Array[Vector2] = [fruits[0].position, fruits[1].position]


func _on_snake_ate_fruit() -> void:
	snake_ate_fruit.emit()


func _on_snake_died() -> void:
	get_tree().call_group("fruits", "queue_free")
	snake_died.emit()
	

func start_snake() -> void:
	snake.start()
	
	
func reset_snake() -> void:
	snake.reset()
	
	
func reset_fruits() -> void:
	fruits.clear()
	
	for i in range(initial_fruit_positions.size()):
		var fruit: Node2D = fruit_scene.instantiate()
		fruit.position = initial_fruit_positions[i]
		
		fruits.append(fruit)
		add_child(fruit)
