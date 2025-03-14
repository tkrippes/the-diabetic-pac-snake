extends Node2D

enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT,
}

@export var tile_size: int = 32

@onready var head: CharacterBody2D = $Head
@onready var bodies: Array[CharacterBody2D] = [$Body]
@onready var tail: CharacterBody2D = $Tail

var _current_direction := Direction.RIGHT;


func _on_movement_timer_timeout() -> void:
	_move_tail()
	_move_bodies()
	_move_head()

	
func _move_head() -> void:
	var position_offset: Vector2
	
	match _current_direction:
		Direction.UP:
			position_offset = Vector2(0, -tile_size)
		Direction.DOWN:
			position_offset = Vector2(0, tile_size)
		Direction.LEFT:
			position_offset = Vector2(-tile_size, 0)
		Direction.RIGHT:
			position_offset = Vector2(tile_size, 0)
	
	head.position += position_offset
	
	
func _move_bodies() -> void:
	bodies.front().position = head.position
	
	for i in range(1, bodies.size()):
		bodies[i].position = bodies[i - 1].position
		
		
func _move_tail() -> void:
	tail.position = bodies.back().position
