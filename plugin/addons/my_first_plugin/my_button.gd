@tool
extends Button


func _enter_tree() -> void:
	pressed.connect(_clicked)


func _clicked():
	print("You clicked me!")
