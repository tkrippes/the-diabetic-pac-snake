class_name SpawnController
extends Node

@export var scene: PackedScene
@export var spawn_timeout: float
@export var despawn_timeout: float

@export var tile_size: int = 32
@export var grid_min_position := Vector2i(1, 1)
@export var grid_max_position := Vector2i(18, 13)
@export var grid_offset := Vector2i(16, 16)

var _current_node: Node2D = null
var _start_timer := false
var _elapsed_time := 0.0


func _process(delta: float) -> void:
	if _start_timer:
		_elapsed_time += delta

		if _current_node == null and _elapsed_time > spawn_timeout:
			_spawn_node(tile_size * Vector2i(randi_range(grid_min_position.x, grid_max_position.x),
				randi_range(grid_min_position.y, grid_max_position.y)) + grid_offset)
			_elapsed_time = 0.0
		elif _current_node != null and _elapsed_time > despawn_timeout:
			_despawn_node()
			_elapsed_time = 0.0


func start() -> void:
	_start_timer = true


func stop() -> void:
	_start_timer = false
	_elapsed_time = 0.0
	if _current_node != null:
		_despawn_node()


func reset_timer() -> void:
	_elapsed_time = 0.0


func _spawn_node(position: Vector2i) -> void:
	_current_node = scene.instantiate()
	_current_node.position = position
	
	add_child(_current_node)


func _despawn_node() -> void:
	_current_node.queue_free()
	_current_node = null
