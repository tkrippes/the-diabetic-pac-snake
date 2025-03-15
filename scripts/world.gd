class_name World
extends Node2D

signal snake_died
signal fruit_eaten

@onready var snake: Snake = $Snake
@onready var banana: Fruit = $Banana


func _on_snake_died() -> void:
	get_tree().call_group("fruits", "queue_free")
	snake_died.emit()
	

func start_snake() -> void:
	snake.start()
	
	
func reset_snake() -> void:
	snake.reset()


func _on_fruit_eaten() -> void:
	fruit_eaten.emit()
