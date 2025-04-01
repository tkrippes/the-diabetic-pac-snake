class_name UserInterface
extends Control
## UserInterface manages the UI of the game.


@onready var start_label: Label = $StartLabel
@onready var score_label: Label = $ScoreLabel
@onready var pause_label: Label = $PauseLabel
@onready var game_over_label: Label = $GameOverLabel
@onready var game_won_label: Label = $GameWonLabel
@onready var game_won_effect: CPUParticles2D = $GameWonEffect


## Shows the start label and hides all other labels.
func show_start_label() -> void:
	start_label.show()
	score_label.hide()
	pause_label.hide()
	game_over_label.hide()
	game_won_label.hide()


## Shows the score label and hides all other labels.
func show_score_label() -> void:
	start_label.hide()
	score_label.show()
	pause_label.hide()
	game_over_label.hide()
	game_won_label.hide()


## Updates the score label based on the new score.
func update_score(score: int) -> void:
	score_label.text = "Score: %d" % score


## Shows the pause label.
func show_pause_label() -> void:
	pause_label.show()


## Hides the pause label.
func hide_pause_label() -> void:
	pause_label.hide()


## Shows the game over label and hides all other labels except the score label.
func show_game_over_label() -> void:
	start_label.hide()
	score_label.show()
	pause_label.hide()
	game_over_label.show()
	game_won_label.hide()


## Shows the game won label and hides all other labels except the score label.
## Plays a particle effects as well.
func show_game_won_label() -> void:
	start_label.hide()
	score_label.show()
	pause_label.hide()
	game_over_label.hide()
	game_won_label.show()
	game_won_effect.set_emitting(true)
