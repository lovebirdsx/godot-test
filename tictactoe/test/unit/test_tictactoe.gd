extends GutTest

var tictactoe

func before_each():
	tictactoe = preload("res://tictactoe.gd").new()
	tictactoe.reset_game()


func test_game_initialization():
	assert_eq(tictactoe.get_game_state(), tictactoe.GameState.PLAYING, "游戏状态应为PLAYING")
	assert_eq(tictactoe.get_current_player(), tictactoe.Player.PLAYER_X, "当前玩家应为PLAYER_X")


func test_player_switch():
	tictactoe.set_cell(0, 0)
	assert_eq(tictactoe.get_current_player(), tictactoe.Player.PLAYER_O, "当前玩家应为PLAYER_O")
	tictactoe.set_cell(1, 0)
	assert_eq(tictactoe.get_current_player(), tictactoe.Player.PLAYER_X, "当前玩家应为PLAYER_X")


func test_win_condition():
	tictactoe.set_cell(0, 0)
	tictactoe.set_cell(1, 0)
	tictactoe.set_cell(0, 1)
	tictactoe.set_cell(1, 1)
	tictactoe.set_cell(0, 2)
	assert_eq(tictactoe.get_game_state(), tictactoe.GameState.WIN, "游戏状态应为WIN")
	assert_eq(tictactoe.get_current_player(), tictactoe.Player.PLAYER_X, "当前玩家应为PLAYER_X")


func test_draw_condition():
	tictactoe.set_cell(0, 0)
	tictactoe.set_cell(0, 1)
	tictactoe.set_cell(0, 2)
	tictactoe.set_cell(1, 1)
	tictactoe.set_cell(1, 0)
	tictactoe.set_cell(1, 2)
	tictactoe.set_cell(2, 1)
	tictactoe.set_cell(2, 0)
	tictactoe.set_cell(2, 2)
	assert_eq(tictactoe.get_game_state(), tictactoe.GameState.DRAW, "游戏状态应为DRAW:\n" + str(tictactoe))
