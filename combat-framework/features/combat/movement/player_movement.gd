extends BaseCharacterMovement

class_name PlayerMovement

func get_move_dir() -> Vector2:
	return Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down")).normalized()
