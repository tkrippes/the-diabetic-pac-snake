class_name World
extends Node2D

signal snake_died
signal fruit_eaten

@export var snake_scene: PackedScene

@onready var snake: Snake = $Snake
@onready var banana: Fruit = $Banana


func _on_snake_died() -> void:
	get_tree().call_group("fruits", "queue_free")
	snake_died.emit()
	

func start_snake() -> void:
	snake.start()
	
	
func reset_snake() -> void:
	# TODO: instantiate snake always without setting on scene directly
	# TODO: save start position of snake
	# TODO: do same for fruit
	if not snake:
		snake = snake_scene.instantiate()
		snake.position = Vector2(80, 240)
		snake.died.connect(_on_snake_died)
		add_child(snake)
	snake.reset()


func _on_fruit_eaten() -> void:
	snake.add_body()
	fruit_eaten.emit()
