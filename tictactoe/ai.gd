class_name Ai

func get_best_move(board, player):
	var best_score = -(1 << 31)
	var move = null

	for y in range(board.size()):
		for x in range(board[y].size()):
			if board[y][x] == 0:  # 如果该位置为空
				board[y][x] = player
				var score = minimax(board, 0, false, player)
				board[y][x] = 0
				if score > best_score:
					best_score = score
					move = Vector2(x, y)
	return move

func minimax(board, depth, is_maximizing, player):
	var opponent = 2 if player == 1 else 1
	var result = check_winner(board)
	if result != null:
		if result == 1:
			return -10 + depth  # 对手获胜，负分
		elif result == -1:
			return 10 - depth  # AI 获胜，正分
		else:
			return 0  # 平局

	if is_maximizing:
		var best_score = -(1 << 31)
		for y in range(board.size()):
			for x in range(board[y].size()):
				if board[y][x] == 0:
					board[y][x] = player
					var score = minimax(board, depth + 1, false, player)
					board[y][x] = 0
					best_score = max(score, best_score)
		return best_score
	else:
		var best_score = 1 << 31
		for y in range(board.size()):
			for x in range(board[y].size()):
				if board[y][x] == 0:
					board[y][x] = opponent
					var score = minimax(board, depth + 1, true, player)
					board[y][x] = 0
					best_score = min(score, best_score)
		return best_score

func check_winner(board):
	for y in range(board.size()):
		if board[y][0] != 0 and board[y][0] == board[y][1] and board[y][1] == board[y][2]:
			return 1 if board[y][0] == 1 else -1
	for x in range(board[0].size()):
		if board[0][x] != 0 and board[0][x] == board[1][x] and board[1][x] == board[2][x]:
			return 1 if board[0][x] == 1 else -1
	if board[0][0] != 0 and board[0][0] == board[1][1] and board[1][1] == board[2][2]:
		return 1 if board[0][0] == 1 else -1
	if board[0][2] != 0 and board[0][2] == board[1][1] and board[1][1] == board[2][0]:
		return 1 if board[0][2] == 1 else -1
	for row in board:
		for cell in row:
			if cell == 0:
				return null
	return 0
