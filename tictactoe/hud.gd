extends CanvasLayer

class_name Hud

signal start_game

func show_message(msg: String):
	$Message.text = msg


func hide_message():
	$Message.text = ""


func hide_start_button():
	$StartButton.hide()


func show_start_button():
	$StartButton.show()


func _on_start_button_pressed() -> void:
	start_game.emit()
