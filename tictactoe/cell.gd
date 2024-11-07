extends Node2D

class_name Cell

@export var pos: Vector2i

signal clicked

const Constants = preload("res://define.gd")
const State = Constants.State

func set_state(state: State) -> void:
	# 通过设置文本来设置状态
	match state:
		State.EMPTY:
			$Button.text = ""
		State.X:
			$Button.text = "X"
		State.O:
			$Button.text = "O"


func _on_button_pressed() -> void:	
	print(pos)
	clicked.emit()
