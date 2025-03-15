class_name Fruit
extends Area2D

signal eaten


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("snake_parts"):
		eaten.emit()
		queue_free()
