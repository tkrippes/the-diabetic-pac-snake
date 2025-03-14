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
@onready var body_sprites: Array[Sprite2D] = [$Body/Sprite]
@onready var tail: CharacterBody2D = $Tail
@onready var tail_sprite: Sprite2D = $Tail/Sprite


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
	_rotate_tail()
	_move_tail()


func _rotate_tail() -> void:
	var position_offset: Vector2 =  bodies.back().position - tail.position
	_rotate(tail, tail_sprite, _get_direction(position_offset))


func _move_tail() -> void:
	tail.position = bodies.back().position


func _update_bodies() -> void:
	_rotate_bodies()
	_move_bodies()


func _rotate_bodies() -> void:
	var position_offset: Vector2 = head.position - bodies[0].position
	_rotate(bodies[0], body_sprites[0], _get_direction(position_offset))
	
	for i in range(1, bodies.size()):
		position_offset = bodies[i - 1].position - bodies[i].position
		_rotate(bodies[i], body_sprites[i], _get_direction(position_offset))


func _move_bodies() -> void:
	bodies.front().position = head.position
	
	for i in range(1, bodies.size()):
		bodies[i].position = bodies[i - 1].position


func _update_head() -> void:
	_rotate_head()
	_move_head()


func _rotate_head() -> void:
	_rotate(head, head_sprite, _current_direction)


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


func _get_direction(position_offset: Vector2) -> Direction:
	if (position_offset.x < 0):
		return Direction.LEFT
	elif (position_offset.x > 0):
		return Direction.RIGHT
	elif (position_offset.y < 0):
		return Direction.UP
	elif (position_offset.y > 0):
		return Direction.DOWN
	
	return Direction.RIGHT


func _rotate(character: CharacterBody2D, sprite: Sprite2D, direction: Direction) -> void:
	match direction:
		Direction.UP:
			character.rotation_degrees = -90
			sprite.flip_v = false
		Direction.DOWN:
			character.rotation_degrees = 90
			sprite.flip_v = false
		Direction.LEFT:
			character.rotation_degrees = 180
			sprite.flip_v = true
		Direction.RIGHT:
			character.rotation_degrees = 0
			sprite.flip_v = false
