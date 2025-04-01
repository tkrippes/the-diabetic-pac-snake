class_name SpawnController
extends Node
## The spawn controller is responsible for spawning items.
##
## It uses internal timeouts to determine when to spawn or despawn an item.

## The settings for spawning of items.
@export var spawn_settings: SpawnSettings
## The settings of the arena containing sizes as well as currently occupied positions.
@export var arena_settings: ArenaSettings

var _current_item: Node2D = null
var _start_timer := false
var _elapsed_time := 0.0


func _process(delta: float) -> void:
	if _start_timer:
		_elapsed_time += delta

		# there is no current item and a new one should be spawned
		if _current_item == null and _elapsed_time > spawn_settings.spawn_timeout:
			_spawn_item(arena_settings.get_random_position())
			_elapsed_time = 0.0
		# there is a current item and it should be despawned
		elif _current_item != null and _elapsed_time > spawn_settings.despawn_timeout:
			_despawn_item()
			_elapsed_time = 0.0


## Starts the spawning process by starting the timer.
func start() -> void:
	_start_timer = true


## Stops the spawning process by stopping the timer.
## Also deletes current item if there is any.
func stop() -> void:
	_start_timer = false
	_elapsed_time = 0.0
	if _current_item != null:
		_despawn_item()


## Resets the timer.
func reset_timer() -> void:
	_elapsed_time = 0.0


## Returns the currently occupied position by the item if it exists.
func get_occupied_positions() -> Array[Vector2]:
	if _current_item == null:
		return []
	
	return [_current_item.global_position]


func _spawn_item(position: Vector2i) -> void:
	# spawn random item
	var item_scene: PackedScene = spawn_settings.item_scenes.pick_random()
	_current_item = item_scene.instantiate()
	_current_item.global_position = position
	
	add_child(_current_item)


func _despawn_item() -> void:
	_current_item.queue_free()
	_current_item = null
