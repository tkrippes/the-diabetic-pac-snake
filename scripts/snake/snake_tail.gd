class_name SnakeTail
# NOTE: snake tail is area 2D so that head does not collide with the tail
# the tail is moved after the head so that when the head moves into the tail, it should actually already be gone
extends Area2D

@onready var sprite: Sprite2D = $Sprite
