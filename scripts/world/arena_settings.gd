class_name ArenaSettings
extends Resource
## ArenaSettings is responsible for the current settings of the arena.
##
## Saves the sizes of the arena and the playable area.
## Saves the currently occupied positions.
## Offers a function to get a new random position based on the playable area and the occupied positions.

## The tile size of one tile of the arena.
@export var tile_size: int
## The minimum grid position (tile position, top left) where the snake can move or items can be placed.
## This excludes the walls of the arena.
@export var grid_min_position: Vector2i
## The maximum grid position (tile position, bottom right) where the snake can move or items can be placed.
## This excludes the walls of the arena.
@export var grid_max_position: Vector2i
## The offset by which the snake or the items are moved / placed in relation to the upper left corner of a tile.
@export var grid_offset: Vector2i

var _occupied_grid_positions: Array[Vector2i] = []


## Sets the currently occupied grid positions.
## Transforms the global positions into grid positions.
## Used for determining which position is still free.
func set_occupied_grid_position(positions: Array[Vector2]) -> void:
	_occupied_grid_positions.assign(positions.map(
		func(position: Vector2) -> Vector2i: return (Vector2i(position) - grid_offset) / tile_size))


## Determines (in global coordinates) a random, still free, position in the arena.
func get_random_position() -> Vector2i:
	var grid_position: Vector2i = _get_random_grid_position()
	# if position is occupied find another position until a free one is found
	while _occupied_grid_positions.find(grid_position) != -1:
		grid_position = _get_random_grid_position()
		
	return tile_size * grid_position + grid_offset

	
func _get_random_grid_position() -> Vector2i:
	return Vector2i(randi_range(grid_min_position.x, grid_max_position.x),
		randi_range(grid_min_position.y, grid_max_position.y))
