extends Node


var test: int = 0
var all_tests: Array[Callable] = [
	_test_texture_rect,
	_test_box_container,
	_test_grid_container,
	_test_tab_container,
]
const SAVE_PATH = "user://save.dat"


func _test_texture_rect():
	var canvas = CanvasLayer.new()
	add_child(canvas)

	var rect = TextureRect.new()
	rect.texture = load("res://icon.svg")
	rect.anchor_left = 0.5
	rect.anchor_right = 0.5
	rect.anchor_top = 0.5
	rect.anchor_bottom = 0.5
	var texture_size = rect.texture.get_size()
	rect.offset_left = -texture_size.x / 2
	rect.offset_right = texture_size.x / 2
	rect.offset_top = -texture_size.y / 2
	rect.offset_bottom = texture_size.y / 2
	canvas.add_child(rect)


func _test_box_container():
	var canvas = CanvasLayer.new()
	add_child(canvas)

	var container = HBoxContainer.new()
	for i in range(3):
		var rect = TextureRect.new()
		rect.texture = load("res://icon.svg")
		container.add_child(rect)

	container.anchor_left = 0.5
	container.anchor_right = 0.5
	container.anchor_top = 0.5
	container.anchor_bottom = 0.5
	canvas.add_child(container)

	# 居中对齐
	var size = container.get_combined_minimum_size()
	container.offset_left = -size.x / 2
	container.offset_right = size.x / 2
	container.offset_top = -size.y / 2
	container.offset_bottom = size.y / 2


func _test_grid_container():
	var canvas = CanvasLayer.new()
	add_child(canvas)

	var container = GridContainer.new()
	container.columns = 3
	for i in range(9):
		var rect = TextureRect.new()
		rect.texture = load("res://icon.svg")
		container.add_child(rect)

	container.anchor_left = 0.5
	container.anchor_right = 0.5
	container.anchor_top = 0.5
	container.anchor_bottom = 0.5
	canvas.add_child(container)

	# 居中对齐
	var size = container.get_combined_minimum_size()
	container.offset_left = -size.x / 2
	container.offset_right = size.x / 2
	container.offset_top = -size.y / 2
	container.offset_bottom = size.y / 2


func _test_tab_container():
	var canvas = CanvasLayer.new()
	add_child(canvas)

	var tab = TabContainer.new()
	for i in range(3):
		var rect = TextureRect.new()
		rect.texture = load("res://icon.svg")
		rect.name = "Tab " + str(i)
		rect.scale = Vector2.ONE * float(i + 1)
		
		tab.add_child(rect)

	tab.anchor_left = 0.5
	tab.anchor_right = 0.5
	tab.anchor_top = 0.5
	tab.anchor_bottom = 0.5
	canvas.add_child(tab)

	# 居中对齐
	var size = tab.get_combined_minimum_size()
	tab.offset_left = -size.x / 2
	tab.offset_right = size.x / 2
	tab.offset_top = -size.y / 2
	tab.offset_bottom = size.y / 2


func _load_data():
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		test = file.get_32()
		file.close()
		print("Loaded data: test = ", test)
	else:
		print("Failed to load data")


func _save_data():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_32(test)
		file.close()
		print("Saved data: test = ", test)
	else:
		print("Failed to save data")


func _draw_current_test():
	var label: Label = Label.new()
	var test_fun = all_tests[test]
	var test_name = str(test_fun).split("::")[1]
	label.text = "Left/Right to switch, Current: " + test_name
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(label)


func _ready():
	_load_data()
	_draw_current_test()
	var test_fun = all_tests[test]
	test_fun.call()
	print("Running test: ", test_fun)


func _rover_test(dir: int):
	test += dir
	if test < 0:
		test = all_tests.size() - 1
	if test >= all_tests.size():
		test = 0

	_save_data()
	
	var test_name = all_tests[test]
	print("Running test: ", test_name)
	get_tree().reload_current_scene()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_pressed():
			if event.keycode == KEY_ESCAPE:
				get_tree().quit()
			elif event.keycode == KEY_RIGHT or event.keycode == KEY_UP:
				_rover_test(1)
			elif event.keycode == KEY_LEFT or event.keycode == KEY_DOWN:
				_rover_test(-1)
			else:
				print("Key pressed: ", event.as_text())
