extends Node2D

@export var board: Board
@export var hud: Hud
@export var tictactoe: Tictactoe


func _on_board_cell_clicked(pos: Vector2i) -> void:
	tictactoe.set_cell(pos.x, pos.y)
	board.set_state(pos, tictactoe.current_player)
	if tictactoe.state == tictactoe.GameState.WIN:
		hud.show_message("Player " + str(tictactoe.current_player) + " wins!")
		hud.show_start_button()
	elif tictactoe.state == tictactoe.GameState.DRAW:
		hud.show_message("It's a draw!")
		hud.show_start_button()
	else:
		hud.show_message("Player " + str(tictactoe.current_player) + "'s turn")


func _on_hud_start_game() -> void:
	hud.hide_message()
	hud.hide_start_button()
