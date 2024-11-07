extends Node

class_name Tictactoe

enum Player { NONE = 0, PLAYER_X, PLAYER_O }
enum GameState { PLAYING, DRAW, WIN }
signal game_over(state, winner)
const GRID_SIZE = 3


var board = []
var current_player = Player.PLAYER_X
var state = GameState.PLAYING


func _init():
	reset_game()


func player_to_string(player):
	match player:
		Player.PLAYER_X:
			return "X"
		Player.PLAYER_O:
			return "O"
		Player.NONE:
			return " "


func reset_game():
	board = []
	for i in range(GRID_SIZE):
		var row = []
		for j in range(GRID_SIZE):
			row.append(Player.NONE)
		board.append(row)
	current_player = Player.PLAYER_X
	state = GameState.PLAYING
	

func get_cell(x, y):
	if x < 0 or x >= GRID_SIZE or y < 0 or y >= GRID_SIZE:
		return Player.NONE
	return board[y][x]


func set_cell(x, y):
	if state != GameState.PLAYING:
		return false
	if get_cell(x, y) != Player.NONE:
		return false
	board[y][x] = current_player
	if check_win(x, y):
		state = GameState.WIN
		game_over.emit(state, current_player)
	elif check_draw():
		state = GameState.DRAW
		game_over.emit(state, Player.NONE)
	else:
		switch_player()
	return true


func switch_player():
	current_player = Player.PLAYER_O if current_player == Player.PLAYER_X else Player.PLAYER_X


func check_win(x, y):
	var player = board[y][x]
	# 检查行
	var win = true
	for i in range(GRID_SIZE):
		if board[y][i] != player:
			win = false
			break
	if win:
		return true
	# 检查列
	win = true
	for i in range(GRID_SIZE):
		if board[i][x] != player:
			win = false
			break
	if win:
		return true
	# 检查主对角线
	if x == y:
		win = true
		for i in range(GRID_SIZE):
			if board[i][i] != player:
				win = false
				break
		if win:
			return true
	# 检查副对角线
	if x + y == GRID_SIZE - 1:
		win = true
		for i in range(GRID_SIZE):
			if board[i][GRID_SIZE - 1 - i] != player:
				win = false
				break
		if win:
			return true
	return false


func check_draw():
	for row in board:
		for cell in row:
			if cell == Player.NONE:
				return false
	return true


func get_current_player():
	return current_player


func get_game_state():
	return state


func _to_string() -> String:
	var result = ""
	for row in board:
		for cell in row:
			if cell == Player.PLAYER_X:
				result += "X"
			elif cell == Player.PLAYER_O:
				result += "O"
			else:
				result += " "
		result += "\n"
	return result
