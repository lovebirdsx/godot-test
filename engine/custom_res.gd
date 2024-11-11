extends Resource

class_name CustomResource

const MAX_HEALTH = 100

@export var title: String
@export var size: Vector2
@export var damage: float

signal modified

func set_title(new_name: String):
	title = new_name.capitalize()
	modified.emit()

func get_title():
	return title

func set_damage(new_damage):
	damage = clamp(new_damage, 0, 100)
	modified.emit()

func get_damage():
	return damage

func _init() -> void:
	print('title = ', title, 'size = ', size)
