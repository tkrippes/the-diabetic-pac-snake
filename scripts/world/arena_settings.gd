class_name ArenaSettings
extends Resource

@export var tile_size: int
@export var grid_min_position: Vector2i
@export var grid_max_position: Vector2i
@export var grid_offset: Vector2i

var _occupied_grid_positions: Array[Vector2i] = []


func set_occupied_grid_position(positions: Array[Vector2]) -> void:
	_occupied_grid_positions.assign(positions.map(
		func(position: Vector2) -> Vector2i: return (Vector2i(position) - grid_offset) / tile_size))


func get_random_position() -> Vector2i:
	var grid_position: Vector2i = _get_random_grid_position()
	while _occupied_grid_positions.find(grid_position) != -1:
		grid_position = _get_random_grid_position()
		
	return tile_size * grid_position + grid_offset

	
func _get_random_grid_position() -> Vector2i:
	return Vector2i(randi_range(grid_min_position.x, grid_max_position.x),
		randi_range(grid_min_position.y, grid_max_position.y))
