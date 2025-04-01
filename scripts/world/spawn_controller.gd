class_name SpawnController
extends Node

@export var spawn_settings: SpawnSettings
@export var arena_settings: ArenaSettings

var _current_item: Node2D = null
var _start_timer := false
var _elapsed_time := 0.0


func _process(delta: float) -> void:
	if _start_timer:
		_elapsed_time += delta

		if _current_item == null and _elapsed_time > spawn_settings.spawn_timeout:
			_spawn_item(arena_settings.get_random_position())
			_elapsed_time = 0.0
		elif _current_item != null and _elapsed_time > spawn_settings.despawn_timeout:
			_despawn_item()
			_elapsed_time = 0.0


func start() -> void:
	_start_timer = true


func stop() -> void:
	_start_timer = false
	_elapsed_time = 0.0
	if _current_item != null:
		_despawn_item()


func reset_timer() -> void:
	_elapsed_time = 0.0
	
	
func get_occupied_positions() -> Array[Vector2]:
	if _current_item == null:
		return []
	
	return [_current_item.global_position]


func _spawn_item(position: Vector2i) -> void:
	var item_scene: PackedScene = spawn_settings.item_scenes.pick_random()
	_current_item = item_scene.instantiate()
	_current_item.global_position = position
	
	add_child(_current_item)


func _despawn_item() -> void:
	_current_item.queue_free()
	_current_item = null
