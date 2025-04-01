class_name SpawnSettings
extends Resource
## SpawnSettings is responsible for determining how to spawn an item.
##
## It defines the item scene, after which elapsed time it should spawn and
## after which elapsed time it should despawn.

## The item scenes that can be spawned.
@export var item_scenes: Array[PackedScene]
## The timeout after which a new scene is spawned.
@export var spawn_timeout: float
## The timeout after which the current scene is despawned.
@export var despawn_timeout: float