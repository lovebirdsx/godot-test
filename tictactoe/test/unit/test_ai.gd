extends GutTest

var ai
var tictactoe


func before_each():
	ai = preload("res://ai.gd").new()
	tictactoe = preload("res://tictactoe.gd").new()
	tictactoe.reset_game()


func test_ai_best_move():
	# 设置一个特定的棋盘状态
	# X O
	# X O
	#     X
	tictactoe.set_cell(0, 0)  # X
	tictactoe.set_cell(1, 0)  # O
	tictactoe.set_cell(0, 1)  # X
	tictactoe.set_cell(1, 1)  # O
	tictactoe.set_cell(2, 2)  # X

	var board = tictactoe.board
	var best_move = ai.get_best_move(board, tictactoe.Player.PLAYER_O)
	
	# 检查AI选择的最佳移动
	assert_eq(best_move, Vector2(1, 2), "AI应选择(1, 2)作为最佳移动\n" + str(tictactoe))


func test_ai_block_opponent_win():
	# 设置一个特定的棋盘状态，AI需要阻止对手获胜
	# X O
	# X O
	tictactoe.set_cell(0, 0)  # X
	tictactoe.set_cell(1, 1)  # O
	tictactoe.set_cell(0, 1)  # X
	tictactoe.set_cell(2, 2)  # O

	var board = tictactoe.board
	var best_move = ai.get_best_move(board, tictactoe.Player.PLAYER_O)
	
	# 检查AI选择的最佳移动
	assert_eq(best_move, Vector2(0, 2), "AI应选择(0, 2)来阻止对手获胜\n" + str(tictactoe))
