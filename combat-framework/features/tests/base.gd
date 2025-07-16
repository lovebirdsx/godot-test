@tool

extends Node2D
class_name Base

@export var base_value: int = 10
@export var trigger_my_function: bool = false: set = _set_trigger_my_function

func _ready() -> void:
	print("Base ready")

func _set_trigger_my_function(value: bool) -> void:
	if value:
		print("Triggering my_function")
		
	
