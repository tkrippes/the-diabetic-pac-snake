extends Node
	
var _score: int = 0
var _state: GameState = GameState.START

enum GameState {
	START,
	PLAYING,
	GAME_OVER
}

@onready var world: World = $World
@onready var user_interface: UserInterface = $UserInterface
	

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("enter"):
		if _state == GameState.START:
			_start_game()
		elif _state == GameState.GAME_OVER:
			_restart_game()
	
			
func _on_snake_died() -> void:
	_state = GameState.GAME_OVER
	user_interface.show_game_over_label()
			
			
func _start_game() -> void:
	_update_score(0)
	_state = GameState.PLAYING
	user_interface.show_score_label()
	world.start_snake()
	
	
func _restart_game() -> void:
	_state = GameState.START
	user_interface.show_start_label()
	
	
func _update_score(score: int) -> void:
	_score = score
	user_interface.update_score(_score)