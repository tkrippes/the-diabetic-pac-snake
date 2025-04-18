class_name SnakeController
extends Node2D
## The snake controller is responsible for moving and rotating the snake's parts.
##
## It is responsible for controlling the snake's head, which follows the player's input.
## It is responsible for controlling the snake's bodies, which follow the snake's head.
## It is responsible for controlling the snake's tail, which follows the snake's bodies.
## It is responsible for adding a new body if the snake eats a fruit.
## It sends a signal when the snake dies.
## It is responsible for playing sounds related to the snake.

## The signal emitted when a fruit was eaten by the snake.
signal ate_fruit
## The signal emitted when the snake dies.
signal died

## The direction in which the snake is heading.
enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT,
}

## The settings of the arena containing sizes as well as currently occupied positions.
@export var arena_settings: ArenaSettings
## The time elapsed before the snake moves.
@export var movement_timeout: float = 0.25
## The radius (square) around the snake's head where no items can be spawned.
@export var clear_area_radius: int = 2

@onready var head: SnakeHead = $Head
@onready var bodies: Array[SnakeBody] = [$Body]
@onready var tail: SnakeTail = $Tail
@onready var sound_controller: SnakeSoundController = $SoundController

var _initial_head_position: Vector2
var _initial_body_position: Vector2
var _initial_tail_position: Vector2

var _last_head_position: Vector2
var _last_body_positions: Array[Vector2]

var _last_direction := Direction.RIGHT
var _current_direction := Direction.RIGHT

var _move                  := false
var _elapsed_movement_time := 0.0
var _add_body_on_next_move := false

## The frame of the snake sprite where the mouth is opened
const SNAKE_HEAD_MOUTH_OPENED_FRAME := 4

## The frame of the snake sprite where the mouth is closed.
const SNAKE_HEAD_MOUTH_CLOSED_FRAME := 5

## The frame of the snake sprite where the tail is pointing upwards.
const SNAKE_TAIL_UPPER_FRAME := 0

## The frame of the snake sprite where the tail is pointing in the middle.
const SNAKE_TAIL_MIDDLE_FRAME := 2

## The frame of the snake sprite where the tail is pointing downwards.
const SNAKE_TAIL_LOWER_FRAME := 1


func _ready() -> void:
	_initial_head_position = head.position
	_initial_body_position = bodies[0].position
	_initial_tail_position = tail.position


func _process(_delta: float) -> void:
	if _move:
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


func _physics_process(delta: float) -> void:
	if _move:
		_elapsed_movement_time += delta
		
		# update snake as soon as the movement timeout has been reached
		if _elapsed_movement_time >= movement_timeout:
			_elapsed_movement_time = 0.0
			
			_update_head()
			_update_bodies()
			_update_tail()


## Starts the snake and play the start sound.
func start() -> void:
	_move = true
	sound_controller.play_start_sound()


## Resets the snakes parts.
func reset() -> void:
	_reset_head()
	_reset_bodies()
	_reset_tail()	
	
	show()
	
	_reset_directions()


## Gets the currently occupied positions of the snake including a radius around its head where no items should be spawned.
func get_occupied_positions() -> Array[Vector2]:
	var occupied_positions: Array[Vector2] = []
	# NOTE: clear area of clear_area_radius around snake head
	for i in range(-clear_area_radius, clear_area_radius + 1):
		for j in range(-clear_area_radius, clear_area_radius + 1):
			occupied_positions.append(head.global_position +
				Vector2(i * arena_settings.tile_size, j * arena_settings.tile_size))

	for body in bodies:
		occupied_positions.append(body.global_position)
	
	occupied_positions.append(tail.global_position)
	
	return occupied_positions
	
	
func _update_head() -> void:
	_animate_head()
	_rotate_head()
	_move_head()


func _animate_head() -> void:
	if head.sprite.frame == SNAKE_HEAD_MOUTH_OPENED_FRAME:
		head.sprite.frame = SNAKE_HEAD_MOUTH_CLOSED_FRAME
	else:
		head.sprite.frame = SNAKE_HEAD_MOUTH_OPENED_FRAME


func _rotate_head() -> void:
	_rotate(head, head.sprite, _current_direction)


func _move_head() -> void:
	_last_head_position = head.position
	var position_offset: Vector2

	match _current_direction:
		Direction.UP:
			position_offset = Vector2(0, -arena_settings.tile_size)
		Direction.DOWN:
			position_offset = Vector2(0, arena_settings.tile_size)
		Direction.LEFT:
			position_offset = Vector2(-arena_settings.tile_size, 0)
		Direction.RIGHT:
			position_offset = Vector2(arena_settings.tile_size, 0)
	
	# NOTE: needed to take into account recent snake head rotation
	head.collision_detector.force_raycast_update()
	# detect collision on next move before actually moving the snake
	# this prevents strange things from happening when two bodies collide
	if head.collision_detector.is_colliding():
		var collider: Node = head.collision_detector.get_collider()
		if collider is Wall:
			sound_controller.play_death_by_wall_sound()
			_die()
		elif collider is SnakeBody:
			sound_controller.play_death_by_self_digestion_sound()
			_die()
		elif collider.is_in_group("sweets"):
			sound_controller.play_death_by_sweets_sound()
			_die()
		elif collider.is_in_group("fruits"):
			_add_body_on_next_move = true
			sound_controller.play_fruit_eating_sound()
			collider.queue_free()
			head.sprite.frame = SNAKE_HEAD_MOUTH_CLOSED_FRAME
			ate_fruit.emit()
	
	# NOTE: collision already detected with collision detector of snake head
	var _collision := head.move_and_collide(position_offset)

	_last_direction = _current_direction


func _update_bodies() -> void:
	_move_bodies()
	_rotate_bodies()


func _move_bodies() -> void:
	_last_body_positions.clear()
	_last_body_positions.append(bodies[0].position)

	# first body follows head
	bodies[0].position = _last_head_position

	# all other bodies follow preceding body
	for i in range(1, bodies.size()):
		_last_body_positions.append(bodies[i].position)
		bodies[i].position = _last_body_positions[i - 1]
		
	if _add_body_on_next_move:
		_add_body()
		


func _rotate_bodies() -> void:
	var position_offset: Vector2 = head.position - bodies[0].position
	_rotate(bodies[0], bodies[0].sprite, _get_direction(position_offset))

	for i in range(1, bodies.size()):
		position_offset = bodies[i - 1].position - bodies[i].position
		_rotate(bodies[i], bodies[i].sprite, _get_direction(position_offset))
	
	
func _add_body() -> void:
	var new_body: SnakeBody = bodies[-1].duplicate() as SnakeBody
	new_body.position = _last_body_positions[-1]
	bodies.append(new_body)
	add_child(new_body)
	
	# INFO: set last body position to tail position so that tail does not move
	_last_body_positions.append(tail.position)
	_add_body_on_next_move = false
	
	
func _update_tail() -> void:
	_animate_tail()
	_move_tail()
	_rotate_tail()


func _animate_tail() -> void:
	if tail.sprite.frame == SNAKE_TAIL_MIDDLE_FRAME or tail.sprite.frame == SNAKE_TAIL_LOWER_FRAME:
		tail.sprite.frame = SNAKE_TAIL_UPPER_FRAME
	else:
		tail.sprite.frame = SNAKE_TAIL_LOWER_FRAME


func _move_tail() -> void:
	# follow last body
	tail.position = _last_body_positions[-1]


func _rotate_tail() -> void:
	var position_offset: Vector2 =  bodies[-1].position - tail.position
	_rotate(tail, tail.sprite, _get_direction(position_offset))


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


func _rotate(character: CollisionObject2D, sprite: Sprite2D, direction: Direction) -> void:
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
	_move = false
	_elapsed_movement_time = 0.0
	_add_body_on_next_move = false
	
	died.emit()
	hide()


func _reset_head() -> void:
	head.position = _initial_head_position
	head.rotation_degrees = 0
	head.sprite.flip_v = false
	head.sprite.frame = SNAKE_HEAD_MOUTH_OPENED_FRAME


func _reset_bodies() -> void:
	for i in range(1, bodies.size()):
		bodies[i].queue_free()
	
	# NOTE: ignore error code
	var _error_code := bodies.resize(1)
	bodies[0].position = _initial_body_position
	bodies[0].rotation_degrees = 0
	bodies[0].sprite.flip_v = false


func _reset_tail() -> void:
	tail.position = _initial_tail_position
	tail.rotation_degrees = 0
	tail.sprite.flip_v = false
	tail.sprite.frame = SNAKE_TAIL_MIDDLE_FRAME


func _reset_directions() -> void:
	_last_direction = Direction.RIGHT
	_current_direction = Direction.RIGHT
