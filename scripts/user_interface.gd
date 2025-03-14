class_name UserInterface
extends Control


@onready var start_label: Label = $StartLabel
@onready var score_label: Label = $ScoreLabel
@onready var game_over_label: Label = $GameOverLabel


func show_start_label() -> void:
	start_label.visible = true
	score_label.visible = false
	game_over_label.visible = false
	
	
func show_score_label() -> void:
	start_label.visible = false
	score_label.visible = true
	game_over_label.visible = false


func update_score(score: int) -> void:
	score_label.text = "Score: %d" % score
	
	
func show_game_over_label() -> void:
	start_label.visible = false
	score_label.visible = false
	game_over_label.visible = true