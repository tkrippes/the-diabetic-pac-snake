class_name SpawnController
extends Node

@export var spawn_settings: SpawnSettings
@export var arena_settings: ArenaSettings

var _current_node: Node2D = null
var _start_timer := false
var _elapsed_time := 0.0


func _process(delta: float) -> void:
	if _start_timer:
		_elapsed_time += delta

		if _current_node == null and _elapsed_time > spawn_settings.spawn_timeout:
			_spawn_node(arena_settings.get_random_position())
			_elapsed_time = 0.0
		elif _current_node != null and _elapsed_time > spawn_settings.despawn_timeout:
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
	var scene: PackedScene = spawn_settings.scenes.pick_random()
	_current_node = scene.instantiate()
	_current_node.position = position
	
	add_child(_current_node)


func _despawn_node() -> void:
	_current_node.queue_free()
	_current_node = null
