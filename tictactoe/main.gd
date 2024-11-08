extends Node2D

@export var board: Board
@export var hud: Hud

var tictactoe:Tictactoe = Tictactoe.new()
var ai:Ai = Ai.new()

func _ready() -> void:
	hud.show_start_button()
	hud.show_message("Press Start")
	tictactoe.game_over.connect(_on_logic_game_over)


func start_game() -> void:
	tictactoe.reset_game()
	board.start()
	hud.hide_start_button()
	hud.show_message("Player " + tictactoe.player_to_string(tictactoe.current_player) + "'s turn")


func win(player: Tictactoe.Player) -> void:
	board.end()
	var message = "Player " + tictactoe.player_to_string(player) + " wins!"
	hud.show_message(message)
	await get_tree().create_timer(2.0).timeout
	hud.show_start_button()


func draw() -> void:
	board.end()
	hud.show_message("It's a draw!")
	await get_tree().create_timer(2.0).timeout
	hud.show_start_button()


func _on_board_cell_clicked(pos: Vector2i) -> void:
	board.set_state(pos, tictactoe.current_player)
	tictactoe.set_cell(pos.x, pos.y)
	if tictactoe.state == tictactoe.GameState.PLAYING:
		hud.show_message("Player " + tictactoe.player_to_string(tictactoe.current_player) + "'s turn")

		if tictactoe.current_player == tictactoe.Player.PLAYER_O:
			var move = ai.get_best_move(tictactoe.board, tictactoe.current_player)
			await get_tree().create_timer(0.5).timeout
			hud.show_message("Player " + tictactoe.player_to_string(tictactoe.current_player) + " is thinking...")
			await get_tree().create_timer(0.5).timeout
			_on_board_cell_clicked(move)


func _on_hud_start_game() -> void:
	start_game()


func _on_logic_game_over(state: Tictactoe.GameState, winner: Tictactoe.Player) -> void:
	match state:
		Tictactoe.GameState.WIN:
			win(winner)
		Tictactoe.GameState.DRAW:
			draw()
		
