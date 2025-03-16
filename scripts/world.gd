class_name World
extends Node2D

signal snake_died
signal fruit_eaten

@export var fruit_scene: PackedScene

@onready var snake: Snake = $Snake
@onready var fruits: Array[Fruit] = [$Banana1, $Banana2]
@onready var initial_fruit_positions: Array[Vector2] = [fruits[0].position, fruits[1].position]


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
		var fruit: Fruit = fruit_scene.instantiate()
		fruit.position = initial_fruit_positions[i]
		var _error_code := fruit.eaten.connect(_on_fruit_eaten)
		
		fruits.append(fruit)
		add_child(fruit)


func _on_fruit_eaten() -> void:
	snake.add_body()
	fruit_eaten.emit()
