@tool
extends EditorPlugin

var dock: Control


func _enter_tree() -> void:
	dock = preload("my_dock.tscn").instantiate()
	add_control_to_dock(DOCK_SLOT_LEFT_UL, dock)


func _exit_tree() -> void:
	remove_control_from_docks(dock)
	dock.free()
