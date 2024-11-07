extends Node2D

class_name Board

signal cell_clicked(pos: Vector2i)


const Constants = preload("res://define.gd")
const State = Constants.State


@export var cells: Array[Cell] = []


func _ready():
	for cell in cells:
		cell.clicked.connect(_on_cell_clicked.bind(cell))
		cell.set_state(State.EMPTY)


func set_state(pos: Vector2i, type: State):
	var cell: Cell = cells[pos.x * 3 + pos.y]
	cell.set_state(type)


func _on_cell_clicked(cell: Cell):
	print("Cell clicked:", cell.pos)
	cell_clicked.emit(cell.pos)
