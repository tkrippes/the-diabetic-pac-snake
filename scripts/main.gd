extends Node
	
var _score: int = 0
var _state: GameState = GameState.START

enum GameState {
	START,
	RUNNING,
	PAUSED,
	GAME_OVER
}

@onready var world: World = $World
@onready var user_interface: UserInterface = $UserInterface
@onready var sound_controller: SoundController = $SoundController
	

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("enter"):
		if _state == GameState.START:
			_start_game()
		elif _state == GameState.GAME_OVER:
			_restart_game()
	elif Input.is_action_just_pressed("pause"):
		if _state == GameState.RUNNING:
			get_tree().paused = true
			user_interface.show_pause_label()
			sound_controller.play_pause_sound()
			_state = GameState.PAUSED
		elif _state == GameState.PAUSED:
			get_tree().paused = false
			user_interface.hide_pause_label()
			sound_controller.play_unpause_sound()
			_state = GameState.RUNNING

	
			
func _on_snake_ate_fruit() -> void:
	_set_score(_score + 1)
	
			
func _on_snake_died() -> void:
	_state = GameState.GAME_OVER
	user_interface.show_game_over_label()
			
			
func _start_game() -> void:
	_set_score(0)
	_state = GameState.RUNNING
	user_interface.show_score_label()
	world.start()
	

func _restart_game() -> void:
	_state = GameState.START
	user_interface.show_start_label()
	world.reset()
	
	
func _set_score(score: int) -> void:
	_score = score
	user_interface.update_score(_score)
