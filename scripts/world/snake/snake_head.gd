class_name SnakeHead
extends CharacterBody2D
## The SnakeHead is the head of the snake.
##
## It is the first part of the snake that is moved and it is setup to be able to detect collisions.

@onready var sprite: Sprite2D = $Sprite
@onready var collision_detector: RayCast2D = $CollisionDetector
