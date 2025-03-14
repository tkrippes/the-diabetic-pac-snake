extends Node2D

enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT,
}

@export var tile_size: int = 32

@onready var head: CharacterBody2D = $Head
@onready var head_sprite: Sprite2D = $Head/Sprite
@onready var bodies: Array[CharacterBody2D] = [$Body]
@onready var bodySprites: Array[Sprite2D] = [$Body/Sprite]
@onready var tail: CharacterBody2D = $Tail
@onready var tailSprite: Sprite2D = $Tail/Sprite


var _last_direction := Direction.RIGHT
var _current_direction := Direction.RIGHT


func _process(_delta: float) -> void:
	if Input.is_action_pressed("move_up"):
		if _last_direction != Direction.DOWN:
			_current_direction = Direction.UP
	elif Input.is_action_pressed("move_down"):
		if _last_direction != Direction.UP:
			_current_direction = Direction.DOWN
	elif Input.is_action_pressed("move_left"):
		if _last_direction != Direction.RIGHT:
			_current_direction = Direction.LEFT
	elif Input.is_action_pressed("move_right"):
		if _last_direction != Direction.LEFT:
			_current_direction = Direction.RIGHT


func _on_movement_timer_timeout() -> void:
	_update_tail()
	_update_bodies()
	_update_head()


func _update_tail() -> void:
	tail.position = bodies.back().position

func _update_bodies() -> void:
	bodies.front().position = head.position
	
	for i in range(1, bodies.size()):
		bodies[i].position = bodies[i - 1].position


func _update_head() -> void:
	_move_head()
	_rotate_head()


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
	_last_direction = _current_direction


func _rotate_head() -> void:
	match _current_direction:
		Direction.UP:
			head_sprite.flip_h = false
			head_sprite.rotation_degrees = -90
		Direction.DOWN:
			head_sprite.flip_h = false
			head_sprite.rotation_degrees = 90
		Direction.LEFT:
			head_sprite.flip_h = true
			head_sprite.rotation_degrees = 0
		Direction.RIGHT:
			head_sprite.flip_h = false
			head_sprite.rotation_degrees = 0
