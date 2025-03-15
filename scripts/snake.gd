class_name Snake
extends Node2D

signal died

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

@onready var movement_timer: Timer = $MovementTimer

var _head_initial_position: Vector2
var _body_initial_position: Vector2
var _tail_initial_position: Vector2

var _last_head_position: Vector2
var _last_body_position: Vector2

var _last_direction := Direction.RIGHT
var _current_direction := Direction.RIGHT


func _ready() -> void:
	_head_initial_position = head.position
	_body_initial_position = bodies[0].position
	_tail_initial_position = tail.position


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("move_up"):
		if _last_direction != Direction.DOWN:
			_current_direction = Direction.UP
	elif Input.is_action_just_pressed("move_down"):
		if _last_direction != Direction.UP:
			_current_direction = Direction.DOWN
	elif Input.is_action_just_pressed("move_left"):
		if _last_direction != Direction.RIGHT:
			_current_direction = Direction.LEFT
	elif Input.is_action_just_pressed("move_right"):
		if _last_direction != Direction.LEFT:
			_current_direction = Direction.RIGHT


func _on_movement_timer_timeout() -> void:
	_update_head()
	_update_bodies()
	_update_tail()
	
	
func start() -> void:
	movement_timer.start()
	
	
func reset() -> void:
	_reset_head()
	_reset_bodies()
	_reset_tail()	
	
	show()
	
	_reset_directions()
	
	
func _update_head() -> void:
	_move_head()
	_rotate_head()


func _move_head() -> void:
	_last_head_position = head.position
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

	var collision := head.move_and_collide(position_offset)
	if (collision):
		if (collision.get_collider() as Node).is_in_group("walls"):
			_die()

	_last_direction = _current_direction


func _rotate_head() -> void:
	_rotate(head, head_sprite, _current_direction)


func _update_bodies() -> void:
	_move_bodies()
	_rotate_bodies()


func _move_bodies() -> void:
	_last_body_position = bodies[-1].position

	bodies[0].position = _last_head_position

	for i in range(1, bodies.size()):
		bodies[i].position = bodies[i - 1].position


func _rotate_bodies() -> void:
	var position_offset: Vector2 = head.position - bodies[0].position
	_rotate(bodies[0], body_sprites[0], _get_direction(position_offset))

	for i in range(1, bodies.size()):
		position_offset = bodies[i - 1].position - bodies[i].position
		_rotate(bodies[i], body_sprites[i], _get_direction(position_offset))
	
	
func _update_tail() -> void:
	_move_tail()
	_rotate_tail()


func _move_tail() -> void:
	tail.position = _last_body_position


func _rotate_tail() -> void:
	var position_offset: Vector2 =  bodies[-1].position - tail.position
	_rotate(tail, tail_sprite, _get_direction(position_offset))


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

	
func _die() -> void:
	movement_timer.stop()
	died.emit()
	hide()


func _reset_head() -> void:
	head.position = _head_initial_position
	head.rotation_degrees = 0
	head_sprite.flip_v = false


func _reset_bodies() -> void:
	bodies[0].position = _body_initial_position
	bodies[0].rotation_degrees = 0
	body_sprites[0].flip_v = false


func _reset_tail() -> void:
	tail.position = _tail_initial_position
	tail.rotation_degrees = 0
	tail_sprite.flip_v = false


func _reset_directions() -> void:
	_last_direction = Direction.RIGHT
	_current_direction = Direction.RIGHT