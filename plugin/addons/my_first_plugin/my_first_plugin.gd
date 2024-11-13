@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_custom_type("MyButton", "Button", preload("my_button.gd"), preload("icon.svg"))


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	remove_custom_type("MyButton")
