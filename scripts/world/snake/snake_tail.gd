class_name SnakeTail
extends Area2D
## The SnakeTails is the tail of the snake.
##
## Compared to the head and the bodies of the snake, the tail is actually an Area2D, not a CharacterBody2D
## This comes from the fact that we do not want to collide the head with the tail, since the head is always
## moved first, then the bodies and only then the tail. This means that if the head collides with the tail
## the tail should actually already have been moved on.

@onready var sprite: Sprite2D = $Sprite
