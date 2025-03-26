class_name ArenaSettings
extends Resource

@export var tile_size: int
@export var grid_min_position: Vector2i
@export var grid_max_position: Vector2i
@export var grid_offset: Vector2i


func get_random_grid_position() -> Vector2i:
	return tile_size * Vector2i(randi_range(grid_min_position.x, grid_max_position.x),
		randi_range(grid_min_position.y, grid_max_position.y)) + grid_offset