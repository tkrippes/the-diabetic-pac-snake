class_name FruitController
extends Node

@export var fruit_scene: PackedScene
@export var spawn_timeout: float = 3.0
@export var despawn_timeout: float = 10.0

@export var tile_size: int = 32
@export var grid_min_position := Vector2i(1, 1)
@export var grid_max_position := Vector2i(18, 13)
@export var grid_offset := Vector2i(16, 16)

var _current_fruit: Fruit = null
var _start_timer := false
var _elapsed_time := 0.0


func _process(delta: float) -> void:
	if _start_timer:
		_elapsed_time += delta

		if _current_fruit == null and _elapsed_time > spawn_timeout:
			_spawn_fruit(tile_size * Vector2i(randi_range(grid_min_position.x, grid_max_position.x),
				randi_range(grid_min_position.y, grid_max_position.y)) + grid_offset)
			_elapsed_time = 0.0
		elif _current_fruit != null and _elapsed_time > despawn_timeout:
			_despawn_fruit()
			_elapsed_time = 0.0


func start() -> void:
	_start_timer = true


func stop() -> void:
	_start_timer = false
	_elapsed_time = 0.0
	if _current_fruit != null:
		_despawn_fruit()


func reset_timer() -> void:
	_elapsed_time = 0.0


func _spawn_fruit(position: Vector2i) -> void:
	_current_fruit = fruit_scene.instantiate()
	_current_fruit.position = position
	
	add_child(_current_fruit)


func _despawn_fruit() -> void:
	_current_fruit.queue_free()
	_current_fruit = null
