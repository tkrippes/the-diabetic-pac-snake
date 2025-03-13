extends Node2D

@export var tile_size: int = 32

@onready var head: CharacterBody2D = $Head
@onready var bodies: Array[CharacterBody2D] = [$Body]
@onready var tail: CharacterBody2D = $Tail


func _on_movement_timer_timeout() -> void:
	_move_head()
	_move_bodies()
	_move_tail()

	
func _move_head() -> void:
	head.position += Vector2(tile_size, 0)
	
	
func _move_bodies() -> void:
	for body in bodies:
		body.position += Vector2(tile_size, 0)
		
		
func _move_tail() -> void:
	tail.position += Vector2(tile_size, 0)